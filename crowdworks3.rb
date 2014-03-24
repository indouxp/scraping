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

  xpath = {}

  search_job_xpath = '//*[@id="GlobalMenu"]/ul/li[1]/a'             # 仕事を探す
  xpath[:xpath] = search_job_xpath + "/img"
  unless driver.find_element(xpath).attribute("alt") == "仕事を探す"
    raise "仕事を探す"
  end
  xpath[:xpath] = search_job_xpath
  driver.find_element(xpath).click

  xpath[:xpath] = '//*[@id="Content"]/div[1]/ul/li[2]/a'  # 開発
  raise "開発" unless driver.find_element(xpath).text == "開発"
  driver.find_element(xpath).click

  xpath[:xpath] =                                         # 表示順=応募期限が近い
  '//*[@id="result_jobs"]/div[1]/div/div[1]/div/div/select/option[5]' 
  raise "応募期限が近い" unless  driver.find_element(xpath).text == "応募期限が近い"
  driver.find_element(xpath).click

  xpath[:xpath] = '//*[@id="result_jobs"]/div[2]/div/ul'
  jobs = driver.find_element(xpath)
end

def login(driver, login_url, user, pass, confirm)
  begin
    driver.get(login_url + "/")
    xpath = {}
    xpath[:xpath] = '//*[@id="SideMenu"]/ul/li[2]/a'
    driver.find_element(xpath).click            # ログイン画面
    xpath[:xpath] = '//*[@id="username"]'
    driver.find_element(xpath).send_key user    # メールアドレス
    xpath[:xpath] = '//*[@id="password"]'
    driver.find_element(xpath).send_key pass    # パスワード
    xpath[:xpath] = '//*[@id="Content"]/div[1]/form/div[2]/p/input[1]'
    driver.find_element(xpath).click            # ログインする
    xpath[:xpath] = '//*[@id="flash-notice"]/div/span'
    elm = driver.find_element(xpath)            # 確認
    if elm.text != confirm
      raise "ログイン失敗"
    end
  rescue Exception => eval
    $logging.puts eval.backtrace.join("\n")
    STDERR.puts eval.backtrace.join("\n")
    STDERR.puts eval
    raise eval
  end
end

main
exit true
