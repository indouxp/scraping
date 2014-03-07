# encoding:utf-8
#
require 'selenium-webdriver'
require "../samples/rb/log010.rb"

logging = Logging.new

driver = Selenium::WebDriver.for :chrome
logging.puts "driver ok"

login_url = "http://crowdworks.jp/login"
driver.get(login_url + "/")
logging.puts "driver.get ok"

driver.find_element(:id, "username").send_keys "indou.tsystem@gmail.com"
logging.puts "find_element username ok"

driver.find_element(:id, "password").send_keys "intatsu1645"
logging.puts "find_element password ok"

driver.find_element(:name, "commit").click
logging.puts "find_element commit ok"

puts "sleeping ..."
sleep

driver.quit
logging.close

exit true
