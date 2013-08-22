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

# aws user activity
activity_url = "https://portal.aws.amazon.com/gp/aws/developer/account?ie=UTF8&action=activity-summary"
driver.navigate.to activity_url

# 請求期間の表示
elms =  driver.find_element(:id, 'activity_table_block').find_elements(:class, 'padbot5')
reg = /以下の日付時点の今月の実績/
ok = false
elms.each do |elm|
  if reg =~ elm.text
    puts elm.text.sub(reg, "")
    ok = true
  end
end
exit 1 unless ok == true

# ドロップダウンリスト
select = Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'statementTimePeriod'))
do_selects = []
select.options.each do |option|
  if /現在の請求明細/ !~ option.text
    do_selects.push(option.text)
  end
end

begin
  do_selects.each do |do_select|
    # ドロップダウンリストを選択することにより再読み込みされる
    #puts do_select
    select =
      Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'statementTimePeriod'))
    select.select_by(:text, do_select)
    wait.until { driver.find_element(:id, 'account_activity_table_tab_content') }
    elm = driver.find_element(:id, 'activity_table_block')
    puts elm.find_element(:class, 'bold').text

    elm = driver.find_element(:id, 'activity_tab_block')
    elm = elm.find_element(:id, 'account_activity_table_tab_content')
    if elm.find_elements(:id, 'summary_funct_tr').empty?
      puts elm.text
    else
      elms = driver.find_elements(:class, 'taupeHeader')
      unless elms.empty?
        puts elms[0].text
      else
        # error
      end
    end
  end

rescue Exception => eval
  STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  # ブラウザ終了
  driver.quit unless $debug
  exit 1
end

driver.quit unless $debug
exit 0
