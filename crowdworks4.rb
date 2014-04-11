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

  #html = driver.page_source # htmlを取得
  #doc = Nokogiri::HTML.parse(html, nil, 'UTF-8')
  #puts html
  #puts "-----"
  base_url = "https://crowdworks.jp"
  no = 0
  done = false
  until done
    lis = driver.find_elements(:xpath => '//*[@id="result_jobs"]/div[2]/div/ul/li')
    lis.size.times do | count |
      job = driver.find_element(:xpath => '//*[@id="result_jobs"]/div[2]/div/ul/li[' + "#{count + 1}" + ']')
      if job.tag_name == 'li'
        ref = job.attribute('data-href')
        text = job.text.gsub(/気になる！リストに追加\n?/, "")
      else
        raise "tag_name is not 'li'"
      end
      if /募集終了/ =~ job.text
        done = true
        break
      end
      no += 1
      puts "====================================#{no}"
      puts text
      puts "#{base_url}/#{ref}"
    end
    unless done
      driver.find_element(:class => 'to_next_page').click
    end
  end
  driver.quit
end

=begin
[:inspect
 :==
 :eql?
 :hash
 :click
 :tag_name
 :attribute
 :text
 :send_keys
 :send_key
 :clear
 :enabled?
 :selected?
 :displayed?
 :submit
 :css_value
 :style
 :location
 :location_once_scrolled_into_view
 :size
 :first
 :all
 :[]
 :ref
 :to_json
 :as_json
 :find_element
 :find_elements
 :nil?
 :===
 :=~
 :!~
 :<=>
 :class
 :singleton_class
 :clone
 :dup
 :taint
 :tainted?
 :untaint
 :untrust
 :untrusted?
 :trust
 :freeze
 :frozen?
 :to_s
 :methods
 :singleton_methods
 :protected_methods
 :private_methods
 :public_methods
 :instance_variables
 :instance_variable_get
 :instance_variable_set
 :instance_variable_defined?
 :remove_instance_variable
 :instance_of?
 :kind_of?
 :is_a?
 :tap
 :send
 :public_send
 :respond_to?
 :extend
 :display
 :method
 :public_method
 :define_singleton_method
 :object_id
 :to_enum
 :enum_for
 :equal?
 :!
 :!=
 :instance_eval
 :instance_exec
 :__send__
 :__id__]

=end


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
