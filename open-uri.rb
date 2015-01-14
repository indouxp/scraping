# encoding:utf-8
#
require 'open-uri'

uri = 
  "http://docs.ruby-lang.org/ja/2.1.0/doc/index.html"
open(uri) { |f|
  f.each_line { |line|
    p line
  }
} 
