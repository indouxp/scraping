require 'selenium-webdriver'

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome

mail_address = 'tatsuo-i@mtb.biglobe.ne.jp'
password = 'InTatsu$1645'

login_url = "https://portal.aws.amazon.com/gp/aws/manageYourAccount"
driver.navigate.to login_url

# user/pass
driver.find_elements(:name, 'create')[1].click
elm_user = driver.find_element(:id, 'ap_email')
elm_user.clear  # chromeの覚えているユーザ名をクリア
elm_user.send_keys(mail_address)
elm_pass = driver.find_element(:id, 'ap_password')
elm_pass.clear  # chromeの覚えているパスワードをクリア
elm_pass.send_keys(password)

driver.find_element(:id, 'signInSubmit').click

activity_url = "https://portal.aws.amazon.com/gp/aws/developer/account?ie=UTF8&action=activity-summary"
driver.navigate.to activity_url

select = Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'statementTimePeriod'))
count = 0
select.options.each do |i|
  select.select_by(:index, count)
  count += 1
end

# HTMLページの操作・解析をごにょごにょ
sleep 10

# ブラウザ終了
driver.quit
