require 'selenium-webdriver'
$debug = true

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

username = 'tatsuo-i@mtb.biglobe.ne.jp'
password = 'InTatsu$1645'

# aws 
login_url = "https://portal.aws.amazon.com/gp/aws/manageYourAccount"
driver.navigate.to login_url

# user/pass
driver.find_elements(:name, 'create')[1].click
elm_user = driver.find_element(:id, 'ap_email')
elm_user.clear  # chromeの覚えているユーザ名をクリア
elm_user.send_keys(username)
elm_pass = driver.find_element(:id, 'ap_password')
elm_pass.clear  # chromeの覚えているパスワードをクリア
elm_pass.send_keys(password)

driver.find_element(:id, 'signInSubmit').click

elm = driver.find_element(:id, 'leftRail').
        find_element(:id, 'subNavA').
        find_element(:class, 'decoratedBox').
        find_element(:class, 'body').
        find_element(:class, 'liner').
        find_element(:xpath, 'ul/li[1]/a')
if /アカウントアクティビティ/ !~ elm.text
  STDERR.puts "アカウントアクティビティがありません。"
  exit 1
end
elm.click

driver.quit unless $debug
exit 0
