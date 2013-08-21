require 'selenium-webdriver'

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome

# Googleにアクセス
driver.navigate.to "http://google.com"

# HTMLページの操作・解析をごにょごにょ

# ブラウザ終了
driver.quit
