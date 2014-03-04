# -*- coding: utf-8 -*-
#
#
require "selenium-webdriver"
$debug = false

class LetsNotes

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @base_url = "http://panasonic.jp/pc/support/products"
    @driver.manage.timeouts.implicit_wait = 30
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
  end

  def get_url
    @driver.get(@base_url + "/")
  end

  def open_file(file)
    file = Dir.pwd + "/" + file unless /^\// =~ file
    @driver.get("file://" + file)
  end

  def report
    elm_contents_boxs = @driver.find_elements(:class, "contents_box")
    elm_contents_boxs[2..elm_contents_boxs.size-1].each do |elm_contents_box|
      elm_rec = elm_contents_box.find_elements(:tag_name, "tr")
      elm_rec.each do |elm_td|
        puts elm_td
        puts elm_td.text
      end
    end
  end

  def quit
    @driver.quit
  end
end

begin
  letsnotes = LetsNotes.new
  if ARGV.empty?
    letsnotes.get_url 
  else
    letsnotes.open_file(ARGV[0])
  end
  letsnotes.report
  letsnotes.quit
rescue => eval
  STDERR.puts eval.backtrace.join("\n") if $debug
  STDERR.puts eval
  exit 1
ensure
  letsnotes.quit unless $debug
end
exit 0
