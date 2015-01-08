# encoding:utf-8
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'https://my.jcb.co.jp/Login'

module Crawler
  class Myjcb
    include Capybara::DSL

    def login
      visit('/')
      fill_in "userId",
        :with => 'ecu39979'
      fill_in "password",
        :with => 'InTatsu1'
      click_button "ログイン"
    end
  end
end

crawler = Crawler::Myjcb.new
crawler.login

