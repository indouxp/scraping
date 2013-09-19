# *-* coding:utf-8 *-*
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
  elm_tables.each do |table|
    recs = table.find_elements(:xpath, "//tr")
    row_no = 0
    recs.each do |rec|
      unless row_no == 0
        printf "\nNo. %02d\n", row_no
        puts rec.text
      end
      row_no += 1
    end
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
