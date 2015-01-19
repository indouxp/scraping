# encoding:utf-8
require 'selenium-webdriver'

class Convert
  attr_accessor :driver, :element, :elements

  def main(mediaurl)
    url = "http://www.clipconverter.cc/jp/" # youtube変換サイト

    # ブラウザ起動
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to url
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

    @element = @driver.find_element(:name, 'mediaurl')
    @element.send_keys(mediaurl)

    ok = false
    until ok == true
      begin
        @driver.find_element(:id, 'submiturl').click       # 続行
        puts '続行click ok'
        ok = true
      rescue => eval
        STDERR.puts '続行click でエラー'
        STDERR.puts eval
        sleep 1
      end
    end

    ok = false
    until ok == true
      begin
        @driver.find_element(:xpath, '//*[@id="submitconvert"]/input').click   # 開始
        puts '開始click ok'
        ok = true
      rescue => eval
        STDERR.puts '開始click でエラー'
        STDERR.puts eval
        sleep 1
      end
    end

    ok = false
    until ok == true
      begin
        downloads = @driver.find_elements(:id, 'downloadbutton')
        downloads[0].click  # 
        puts 'ダウンロードclick ok'
        ok = true
      rescue => eval
        STDERR.puts 'ダウンロード click でエラー'
        STDERR.puts eval
        sleep 1
      end
    end

    #sleep 5
    #alert = driver.switch_to.alert  # ポップアップボックスを処理する
    #alert.element[1].click
    #alert.accept.click

    # ブラウザ終了
    #driver.quit
  end
end

if __FILE__ == $0
  Convert.new.main ARGV[0]
end
