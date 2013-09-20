# -*- coding: utf-8 -*-
require "selenium-webdriver"
$debug = false

class Crowdworks
  attr_reader :done

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    STDERR.puts @driver if $debug
    @base_url = "http://crowdworks.jp/"
    @driver.manage.timeouts.implicit_wait = 30
    @done = false
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
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
    STDERR.puts @driver if $debug
  end

  def report
    elm_body = @driver.find_element(:id, "top")
    elm_tables = elm_body.find_elements(:xpath, "//table")
    begin
      elm_table = nil
      elm_tables.each do |table|
        classes = table.attribute("class")
        if /jobs/ =~ classes && /mixin-for-list/ =~ classes
          elm_table = table
          break
        end
      end
      raise "ERR01" if elm_table == nil
    rescue => eval
      raise eval
    end
    STDERR.puts "elm_tables:#{elm_tables}" if $debug
    datas = elm_table.find_elements(:xpath, "//tr/td")
    STDERR.puts "datas:#{datas}" if $debug
    record_no = 0
    data_no = 0
    datas.each do |data|
      if data.attribute("class") == "title"
        record_no += 1
        data_no = 1
      end
      if data.attribute("class") == "title"
        printf "\nNo. %02d-%02d\n", record_no, data_no  if      $debug
        printf "\nNo. %02d\n", record_no                unless  $debug
      end
      puts "#{data.attribute("class")}:#{data.text.gsub(/\r\n|\r|\n/, "")}"
      data_no += 1
      if data.attribute("class") == "expired_on" &&
        /募集終了/ =~ data.text
        @done = true
        break
      end
    end
  end

  def next_page
    elm_next_page = @driver.find_element(:link, "次のページ →")
    elm_next_page.click
    STDERR.puts elm_next_page if $debug
  end

  def quit
    @driver.quit
  end
end

begin
  crowdworks = Crowdworks.new
  username = ARGV[0]
  password = ARGV[1]
  crowdworks.login(username, password)
  until crowdworks.done 
    crowdworks.report
    crowdworks.next_page unless crowdworks.done
  end
  
rescue => eval
  STDERR.puts eval.backtrace.join("\n") if $debug
  STDERR.puts eval
ensure
  #crowdworks.quit
end
