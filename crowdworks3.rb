# encoding: utf-8
# SUMMARY:crodworksの募集している仕事を取得
#
require 'selenium-webdriver'
require "../samples/rb/log010.rb"
$logging = Logging.new

def main
  user = "indou.tsystem@gmail.com"
  pass = "intatsu1645"
  confirm = "ログインしました。"
  driver = Selenium::WebDriver.for :chrome
  login_url = "http://crowdworks.jp/login"
  login(driver, login_url, user, pass, confirm)

end

def login(driver, login_url, user, pass, confirm)
  begin
    driver.get(login_url + "/")
    driver.find_element(:xpath => '//*[@id="SideMenu"]/ul/li[2]/a').click # ログイン
    driver.find_element(:xpath => '//*[@id="username"]').send_key user    # メールアドレス
    driver.find_element(:xpath => '//*[@id="password"]').send_key pass    # パスワード
    driver.find_element(
      :xpath => '//*[@id="Content"]/div[1]/form/div[2]/p/input[1]'
    ).click                                                               # ログインする
    elm = driver.find_element(:xpath => '//*[@id="flash-notice"]/div/span')
    if elm.text != confirm
      raise "ログイン失敗"
    end
  rescue Exception => eval
    $logging.put eval.backtrace.join("\n")
    $logging.put eval
  end
end

main
exit true
