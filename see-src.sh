#!/bin/sh
LF=$(printf '\\\012_');LF=${LF%_}

[ $# -ge 1 ] && FILE=$1

cat ${FILE:?}                                               |
  tr -d '\n'                                                |
  sed "s/<\!--[^>]*-->//g"                                  |
  sed "s/\(<\/[a-zA-Z0-9][a-zA-Z0-9]*\)/${LF:?}\1${LF:?}/g" |
  sed "s/\(<[a-zA-Z0-9][a-zA-Z0-9]*\)/${LF:?}\1${LF:?}/g"   | tee ts.1 |
  grep -E -e '(<|id="[^"]*"|class="[^"]*")'                 |
  ruby see-src.rb 
