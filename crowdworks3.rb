# encoding: utf-8
# SUMMARY:crodworksの募集している仕事を取得
#
require 'selenium-webdriver'
require 'nokogiri'
require "../samples/rb/log010.rb"

$logging = Logging.new

def main
  driver = Selenium::WebDriver.for :chrome
  user = "indou.tsystem@gmail.com"
  pass = "intatsu1645"
  confirm = "ログインしました。"
  login_url = "http://crowdworks.jp/login"
  login(driver, login_url, user, pass, confirm)

  params = {}

  search_job_xpath = '//*[@id="GlobalMenu"]/ul/li[1]/a'   # 仕事を探す
  params[:xpath] = search_job_xpath + "/img"
  unless driver.find_element(params).attribute("alt") == "仕事を探す"
    raise "仕事を探す"
  end
  params[:xpath] = search_job_xpath
  driver.find_element(params).click

  params[:xpath] = '//*[@id="Content"]/div[1]/ul/li[2]/a'  # 開発
  raise "開発" unless driver.find_element(params).text == "開発"
  driver.find_element(params).click

  params[:xpath] =                                         # 表示順=応募期限が近い
  '//*[@id="result_jobs"]/div[1]/div/div[1]/div/div/select/option[5]' 
  raise "応募期限が近い" unless  driver.find_element(params).text == "応募期限が近い"
  driver.find_element(params).click

  #source = driver.page_source # htmlを取得
  #doc = Nokogiri::HTML(source)
  #puts doc

  params[:xpath] = '//*[@id="result_jobs"]/div[2]/div/ul'
  jobs = driver.find_element(params)
  rows = jobs.find_elements(:tag_name => 'li')
  count = 0
  rows.each do |row|
    puts row.text
  end
end

def login(driver, login_url, user, pass, confirm)
  begin
    driver.get(login_url + "/")
    params = {}
    params[:xpath] = '//*[@id="SideMenu"]/ul/li[2]/a'
    driver.find_element(params).click            # ログイン画面
    params[:xpath] = '//*[@id="username"]'
    driver.find_element(params).send_key user    # メールアドレス
    params[:xpath] = '//*[@id="password"]'
    driver.find_element(params).send_key pass    # パスワード
    params[:xpath] = '//*[@id="Content"]/div[1]/form/div[2]/p/input[1]'
    driver.find_element(params).click            # ログインする
    params[:xpath] = '//*[@id="flash-notice"]/div/span'
    elm = driver.find_element(params)            # 確認
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

if __FILE__ == $0 
  main
  exit true
end
