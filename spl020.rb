require 'selenium-webdriver'

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome

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

# aws user actity
activity_url = "https://portal.aws.amazon.com/gp/aws/developer/account?ie=UTF8&action=activity-summary"
driver.navigate.to activity_url

wait = Selenium::WebDriver::Wait.new(:timeout => 1) # seconds

select = Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'statementTimePeriod'))
begin
  
  STDERR.puts "01"
  select.select_by(:text, 'May 1 - May 31, 2013')
  STDERR.puts "02"
  wait.until { driver.find_element(:id, 'account_activity_table_tab_content') }
  STDERR.puts "03"

rescue => eval
  STDERR.puts eval
  # ブラウザ終了
  driver.quit
  exit 1
end

select = Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'statementTimePeriod'))
begin
  
  STDERR.puts "11"
  select.select_by(:text, 'June 1 - June 30, 2012')
  STDERR.puts "12"
  wait.until { driver.find_element(:id, 'account_activity_table_tab_content') }
  STDERR.puts "13"

rescue => eval
  STDERR.puts eval
  # ブラウザ終了
  driver.quit
  exit 1
end

driver.quit
exit 0
