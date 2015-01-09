# encoding:utf-8
# myjcbにログインし、利用明細を取得する
#
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'yaml'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'https://my.jcb.co.jp/Login'

module Crawler
  class Myjcb
    include Capybara::DSL

    def login(user, pass)
      visit('/')
      fill_in "userId",
        :with => user
      fill_in "password",
        :with => pass
      click_button "ログイン"
      sleep 5                           # 一時的
      click_link "MyJCBメニュー画面へ"  # ２つリンクがあるのでエラー
    end
  end
end

if __FILE__ == $0
  yaml_file = File.dirname($0) + "/" + "myjcb.txt"
  data = YAML.load_file(yaml_file)
  user = data["user"]
  pass = data["pass"]

  crawler = Crawler::Myjcb.new
  crawler.login(user, pass)
  exit 0
end

