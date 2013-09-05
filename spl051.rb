# *-* coding:utf-8 *-*
# クラウドワークス
require "selenium-webdriver"
$debug = true

# ブラウザ起動
# :chrome, :firefox, :safari, :ie, :operaなどに変更可能
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

begin
  html = "file:///Users/indou/work/scraping/ts.html"
  elm_html = driver.get html
  elm_content = driver.find_element(:id, "ContentContainer")
  elm_table = elm_content.find_element(:xpath, "//div/table/tbody")
  recs = elm_table.find_elements(:xpath, "//tr")
  row_no = 0
  recs.each do |rec|
    unless row_no == 0
      printf "\nNo. %02d\n", row_no
      url = rec.attribute("data-href")
      puts rec.text
    end
    row_no += 1
  end

rescue => eval
  STDERR.puts eval.backtrace.join("\n")
  STDERR.puts eval
  exit 1
ensure
  driver.quit
end
exit 0

__END__

inspect
==
eql?
hash
click
tag_name
attribute
text
send_keys
send_key
clear
enabled?
selected?
displayed?
submit
css_value
style
location
location_once_scrolled_into_view
size
first
all
[]
ref
to_json
as_json
find_element
find_elements
nil?
===
=~
!~
<=>
class
singleton_class
clone
dup
taint
tainted?
untaint
untrust
untrusted?
trust
freeze
frozen?
to_s
methods
singleton_methods
protected_methods
private_methods
public_methods
instance_variables
instance_variable_get
instance_variable_set
instance_variable_defined?
remove_instance_variable
instance_of?
kind_of?
is_a?
tap
send
public_send
respond_to?
extend
display
method
public_method
define_singleton_method
object_id
to_enum
enum_for
equal?
!
!=
instance_eval
instance_exec
__send__
__id__
