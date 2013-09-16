# -*- coding: utf-8 -*-
require "selenium-webdriver"

class Crowdworks
  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @base_url = "http://crowdworks.jp/"
    @driver.manage.timeouts.implicit_wait = 30
  end

  def login(username, password)
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "ログイン").click
    @driver.find_element(:id, "username").send_keys username
    elm_password = @driver.find_element(:id, "password")
    elm_password.clear
    elm_password.send_keys password
    @driver.find_element(:name, "commit").click
    @driver.find_element(:css, "span").click
    @driver.find_element(:link, "開発").click
    @driver.find_element(:css, "option[value=\"-expires\"]").click
  end

  def done
    @driver.quit
  end
end

begin
  crowdworks = Crowdworks.new
  username = ARGV[0]
  password = ARGV[1]
  crowdworks.login(username, password)
rescue => eval
  STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
ensure
  #crowdworks.done
end
