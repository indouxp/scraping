# *-* coding:utf-8 *-*
# クラウドワークス

require "selenium-webdriver"
$debug = true
username = "tatsuo-i@mtb.biglobe.ne.jp"
password = "intatsu1645"

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
  elm_content = driver.find_elements(:id, "Content")
  elm_logins = elm_content.find_element(:class, "login")
  elm_logins.each do | elm |
    puts "----------"
    puts elm.text
  end

rescue => eval
  #STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  exit 1
ensure
  driver.quit unless $debug
end
exit 0
