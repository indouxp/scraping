# *-* coding:utf-8 *-*
# クラウドワークス
require "selenium-webdriver"
$debug = true

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

begin
  html = "file:///home/indou/work/scraping/ts.2.html"
  elm_html = driver.get html
  elm_content = driver.find_element(:id, "Content")
  elm_tmp = elm_content.find_element(:xpath, "//div/form/table")
  puts elm_tmp.text

rescue => eval
  #STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  exit 1
ensure
  driver.quit unless $debug
end
exit 0
