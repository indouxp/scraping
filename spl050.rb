# *-* coding:utf-8 *-*
# クラウドワークス

require "selenium-webdriver"
$debug = true
username = "indou.tsystem@gmail.com"
password = "intatsu1645"
#username = ARGV[0]
#password = ARGV[1]

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

begin
  # aws 
  login_url = "http://crowdworks.jp/"
  driver.navigate.to login_url
  elm_login = driver.find_element(:id, "SideMenu").
                    find_element(:class, "menu").
                    find_element(:class, "login")
  reg = /ログイン/
  if reg =~  elm_login.text
    elm_login.click
  else
    STDERR.puts "#{reg}が存在しません"
    raise
  end
  elm_content = driver.find_element(:id, "Content")
  elm_table = elm_content.find_element(:xpath, "//div/form/table")
  elm_id = elm_table.find_element(:id, "username")
  elm_id.clear
  elm_id.send_keys(username)
  elm_pw = elm_table.find_element(:id, "password")
  elm_pw.clear
  elm_pw.send_keys(password)
  elm_table.find_element(:name, "commit").click

rescue => eval
  STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  exit 1
ensure
  driver.quit unless $debug
end
exit 0
