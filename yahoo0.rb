# encoding: utf-8
# SUMMARY:yahooオークション
#
require 'selenium-webdriver'
require 'yaml'
require "../samples/rb/log010.rb"

$logging = Logging.new

def main
  yaml_file = File.dirname($0) + "/" + "yahoo.txt"
  data = YAML.load_file(yaml_file)
  driver = Selenium::WebDriver.for :chrome
  user = data["user"]
  pass = data["pass"]
  driver.get('http://auctions.yahoo.co.jp/')
  params = {}
  params[:xpath] = '//*[@id="masthead"]/div/div[2]/strong/a'
  driver.find_element(params).click            # ログイン画面
  params[:xpath] = '//*[@id="username"]'
  driver.find_element(params).send_key user    # メールアドレス
  params[:xpath] = '//*[@id="passwd"]'
  driver.find_element(params).send_key pass    # パスワード
  params[:xpath] = '//*[@id=".save"]'
  driver.find_element(params).click            # ログインする
  params[:xpath] = '//*[@id="AucSearchTxt"]'
  driver.find_element(params).send_key "phenom x6"
  params[:xpath] = '//*[@id="AucSearchSbmt"]'
  driver.find_element(params).click
end

if __FILE__ == $0 
  begin
    main
  rescue Exception => eval
    STDERR.puts eval.backtrace.join("\n")
    STDERR.puts eval.to_s
    $logging.puts eval.backtrace.join("\n")
    $logging.puts eval.to_s
    raise eval
  end
  exit true
end

