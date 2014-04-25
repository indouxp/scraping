# encoding: utf-8
# SUMMARY:cpubenchmark
#
require 'open-uri'
require 'nokogiri'
require "../samples/rb/log010.rb"

$logging = Logging.new

def main
  url = 'http://www.cpubenchmark.net/cpu_list.php'
  doc = Nokogiri::HTML(open(url))
  for kind in ['//*[@id="cputable"]/tbody', '//*[@id="multicpu"]/tbody']
    doc.xpath(kind).xpath('tr').each do |elm|
      field = elm.xpath('td')
      name = field[0].inner_text
      if field[1].inner_text =~ /\d/
        cpumark = sprintf("%5d", field[1].inner_text)
      else
        cpumark = sprintf("%5s", field[1].inner_text)
      end
      puts sprintf("%-50s %5s", name, cpumark)
    end
  end
end

if __FILE__ == $0 
  begin
    main
  rescue Exception => eval
    STDERR.puts eval.backtrace.join("\n")
    STDERR.puts eval.to_s
    $logging.puts eval.backtrace.join("\n")
    $logging.puts eval.to_s
    raise eval
  end
  exit true
end

