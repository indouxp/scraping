#!/bin/sh

cat $1                                              |
  tr -d '\n'                                        |
  sed "s/<\!--[^>]*-->//g"                          |
  sed "s/\(<\/[a-zA-Z0-9][a-zA-Z0-9]*\)/\n\1\n/g"   |
  sed "s/\(<[a-zA-Z0-9][a-zA-Z0-9]*\)/\n\1\n/g"     |
  grep -E -e '(<|id="[^"]*"|class="[^"]*")' -e "$2" | tee ts.1 |
  ruby see-src.rb 
