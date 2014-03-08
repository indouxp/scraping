# encoding:utf-8
#
require 'selenium-webdriver'
require "../samples/rb/log010.rb"

def find_element_and_send(driver, selector, selector_name, send_string)
  begin
    elm = driver.find_element(selector, selector_name)
    elm.send_keys(send_string)
  rescue => eval
    puts caller()
    abort "ERROR:#{eval}"
  ensure
    driver.quit
  end
end

def find_element_and_click(driver, selector, selector_name)
  begin
    elm = driver.find_element(selector, selector_name)
    elm.click
    return "selector:#{selector} selector name:#{selector_name}"
  rescue => eval
    puts caller()
    abort "ERROR:#{eval}"
  ensure
    driver.quit
  end
end

logging = Logging.new

driver = Selenium::WebDriver.for :chrome
logging.puts "driver ok"

login_url = "http://crowdworks.jp/login"
driver.get(login_url + "/")
logging.puts "driver.get ok"

find_element_and_send(driver, :id, "username", "indou.tsystem@gmail.com")

find_element_and_send(driver, :id, "password", "intatsu1645")

find_element_and_click(driver, :name, "commit")

driver.quit
logging.close

exit true
