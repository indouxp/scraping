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

select = Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'statementTimePeriod'))

wait = Selenium::WebDriver::Wait.new(:timeout => 1) # seconds

select.select_by(:text, 'May 1 - May 31, 2013')
wait.until { driver.find_element(:id, 'account_activity_table_tab_content') }
puts "step03"
begin
  wait.until { driver.find_element(:class, 'bold padbot5') }
  puts "step04"
rescue => evar
  p $!
  p evar
end
puts "step05"

select.select_by(:text, 'January 1 - January 31, 2010')
wait.until { driver.find_element(:id, 'account_activity_table_tab_content') }
wait.until { driver.find_element(:class, 'bold padbot5') }

sleep 10

# ブラウザ終了
driver.quit
