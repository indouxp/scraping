# coding: utf-8
# クラウドワークス
require "selenium-webdriver"
$debug = true

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

begin
  html = "file:///Users/indou/work/scraping/ts.2"
  driver.get html
  elm_body = driver.find_element(:id, "top")
  elm_tables = elm_body.find_elements(:xpath, "//table")
  begin
    elm_table = nil
    elm_tables.each do |table|
      classes = table.attribute("class")
      if /jobs/ =~ classes && /mixin-for-list/ =~ classes
        elm_table = table
        break
      end
    end
    raise "ERR01" if elm_table == nil
  rescue => eval
    raise eval
  end
  datas = elm_table.find_elements(:xpath, "//tr/td")
  data_no = 0
  datas.each do |data|
    printf "\nNo. %02d/%02d\n", data_no, datas.size
    puts "class:[#{data.attribute("class")}]"
    puts "text:[#{data.text.gsub(/\r\n|\r|\n/, "")}]"
    data_no += 1
  end
rescue => eval
  STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  exit 1
ensure
  driver.quit
end
exit 0

__END__
