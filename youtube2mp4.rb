# encoding:utf-8
# とりあえずは、mp4をダウンロードできる
#
require 'selenium-webdriver'

class Convert
  attr_accessor :driver, :element, :elements, :download

  def main(mediaurl)
    url = "http://www.clipconverter.cc/jp/" # youtube変換サイト

    # ブラウザ起動
    #@driver = Selenium::WebDriver.for :firefox
    @driver = Selenium::WebDriver.for :chrome
    @driver.navigate.to url
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

    @element = @driver.find_element(:name, 'mediaurl')
    @element.send_keys(mediaurl)

    ok = false
    until ok == true
      begin
        @driver.find_element(:id, 'submiturl').click       # 続行
        puts '続行click ok #{Time.now.strftime("%Y/%m/%d %H:%M:%S")}'
        ok = true
      rescue => eval
        STDERR.puts '続行click でエラー、再試行します。'
        #STDERR.puts eval
        sleep 1
      end
    end

    ok = false
    until ok == true
      begin
        @driver.find_element(:xpath, '//*[@id="submitconvert"]/input').click   # 開始
        puts '開始click ok #{Time.now.strftime("%Y/%m/%d %H:%M:%S")}'
        ok = true
      rescue => eval
        STDERR.puts '開始click でエラー、再試行します。'
        #STDERR.puts eval
        sleep 1
      end
    end

    ok = false
    until ok == true
      begin
        downloads = @driver.find_elements(:id, 'downloadbutton')
        @download = downloads[0]
        @download.click  # ２つあるので一つ目
        puts 'ダウンロード click ok #{Time.now.strftime("%Y/%m/%d %H:%M:%S")}'
        ok = true
      rescue => eval
        STDERR.puts 'ダウンロード click でエラー、再試行します。'
        #STDERR.puts eval
        sleep 1
      end
    end
  end

  def finish
    # ブラウザ終了
    @driver.quit
  end
end

if __FILE__ == $0
  download_dir = "/home/indou/ダウンロード"
  ARGV.each do |url|
    c = Convert.new
    c.main url
    file = File.join(download_dir, "*mp4.crdownload")
    until Dir.glob(file) != []
      sleep 1
    end
    while Dir.glob(file) != []
      sleep 1
    end
    puts "done."
    c.finish
  end
end
