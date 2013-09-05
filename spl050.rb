# *-* coding:utf-8 *-*
# クラウドワークス

require "selenium-webdriver"
$debug = true
username = "indou.tsystem@gmail.com"
password = "intatsu1645"
#username = ARGV[0]
#password = ARGV[1]

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

begin
  login_url = "http://crowdworks.jp/"
  driver.navigate.to login_url
  elm_login = driver.find_element(:id, "SideMenu").
                    find_element(:class, "menu").
                    find_element(:class, "login")
  reg = /ログイン/
  if reg =~  elm_login.text
    elm_login.click
  else
    STDERR.puts "#{reg}が存在しません"
    raise
  end
  elm_content = driver.find_element(:id, "Content")
  elm_table = elm_content.find_element(:xpath, "//div/form/table")
  elm_id = elm_table.find_element(:id, "username")
  elm_id.clear
  elm_id.send_keys(username)
  elm_pw = elm_table.find_element(:id, "password")
  elm_pw.clear
  elm_pw.send_keys(password)
  elm_table.find_element(:name, "commit").click
  elm_menu = driver.find_element(:id, "Header").
                    find_element(:id, "HeaderInner").
                    find_element(:id, "GlobalMenu")
  elm_a = elm_menu.find_element(:xpath, "//ul/li")
  elm_a.click

  elm_div = driver.find_element(:class, "select_order")
  elm_dropdown_list = elm_div.find_element(:xpath, "//select")
  select = Selenium::WebDriver::Support::Select.new(elm_dropdown_list)
  do_selects = []
  ok = false
  reg = /応募期限が近い/
  go_text = ""
  select.options.each do |option|
    if reg =~ option.text
      go_text = option.text
      ok = true
    end
  end
  if ok == true
    select.select_by(:text, go_text)
  else
    STDERR.puts "#{reg}がドロップダウンリストに存在しません。"
    raise
  end
  row_no = 0
  while true do
    elm_content = driver.find_element(:id, "ContentContainer")
    elm_table = elm_content.find_element(:xpath, "//div/table")
    recs = elm_table.find_elements(:xpath, "//tr")
    done = false
    recs.each do |rec|
      unless row_no == 0
        if /募集終了/ =~ rec.text 
          STDERR.puts "募集終了文字列が見つかりました。"
          done = true
          break
        end
        printf "\nNo. %02d\n", row_no
        url = rec.attribute("data-href")
        printf "https://crowdworks.jp/%s\n", url
        puts rec.text
      end
      row_no += 1
    end
    if done = true
      break
    end
    reg = /次のページ/
    #elm_a = elm_content.find_element(:xpath, "//div/div/div/div/div/a")
    elm_a = elm_content.find_element(:class, "next_page")
    if reg =~ elm_a.text
      elm_a.click
    else
      STDERR.puts "#{reg}文字列が見つかりません。"
      break
    end
  end

rescue => eval
  STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  exit 1
ensure
  driver.quit unless $debug
end
exit 0
