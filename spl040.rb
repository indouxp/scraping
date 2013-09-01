require "selenium-webdriver"
$debug = true
username = "tatsuo-i@mtb.biglobe.ne.jp"
password = "InTatsu$1645"

# ログイン
def login(driver, username, password)
  driver.find_elements(:name, "create")[1].click # 0: new user 1:returning user
  elm_user = driver.find_element(:id, "ap_email")
  elm_user.clear
  elm_user.send_keys(username)

  elm_pass = driver.find_element(:id, "ap_password")
  elm_pass.clear
  elm_pass.send_keys(password)

  # アカウントの管理画面へ遷移
  driver.find_element(:id, "signInSubmit").click
end

# アカウントアクティビティ
def to_account_activity(driver)
  elm_a = driver.find_element(:id, "leftRail").
          find_element(:id, "subNavA").
          find_element(:class, "decoratedBox").
          find_element(:class, "body").
          find_element(:class, "liner").
          find_element(:xpath, "ul/li[1]/a") # li[1]から始まるみたい
  reg = /アカウントアクティビティ/
  if reg !~ elm_a.text
    STDERR.puts "#{reg}がありません。"
    raise
  end
  elm_a.click # アカウントアクティビティへ遷移
end

# アカウントテクティビティ画面のチェック
def chk_account_activity(driver)
  # Account Activity画面に、以下の日付時点の今月の実績というキーワードがあることを確認
  elms = driver.find_element(:id, "activity_table_block").
          find_elements(:class, "padbot5")
  reg = /以下の日付時点の今月の実績/
  ok = false
  elms.each do |elm|
    if reg =~ elm.text
      #puts elm.text.sub(reg, "")
      ok = true
    end
  end
  if ok != true
    STDERR.puts "#{reg}がありません。"
    raise
  end
end

# 請求明細の表示
def activity_report(driver)
  elm = driver.find_element(:id, "account_activity_table_tab_content")
  elm = elm.find_element(:tag_name, "table")
  if /実績はありません/ =~ elm.text
    puts "  #{elm.text}"
    return
  end
  begin
    elm = driver.find_element(:id, "billingSummary")
    results = elm.find_element(:class, "taupeHeader").text.split("\n")
    puts "  #{results[1]}:#{results[0]}"  # インデントしつつ表示
  rescue => eval
    STDERR.puts eval.backtrace.join("\n")
    STDERR.puts eval
    raise 
  end
end

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

begin
  # aws 
  login_url = "https://portal.aws.amazon.com/gp/aws/manageYourAccount"
  driver.navigate.to login_url
  login(driver, username, password)
  to_account_activity(driver)
  chk_account_activity(driver)
  elm_dropdown_list = driver.find_element(:name, "statementTimePeriod")
  select = Selenium::WebDriver::Support::Select.new(elm_dropdown_list)
  do_selects = []
  select.options.each do |option|
    if /現在の請求明細/ =~ option.text
      puts option.text
    else
      do_selects.push(option.text)
    end
  end
  activity_report(driver)
  do_selects.each do |do_select|
    puts do_select
    elm_dropdown_list = driver.find_element(:name, "statementTimePeriod")
    select = Selenium::WebDriver::Support::Select.new(elm_dropdown_list)
    select.select_by(:text, do_select)
    wait.until { driver.find_element(:id, "account_activity_table_tab_content") }
    activity_report(driver)
  end
rescue => eval
  STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  exit 1
ensure
  driver.quit
end
exit 0
