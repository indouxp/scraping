#!/bin/sh
LF=$(printf '\\\012_');LF=${LF%_}

[ $# -ge 1 ] && FILE=$1

cat ${FILE:?}                                               |
  tr -d '\n'                                                |
  sed "s/<\!--[^>]*-->//g"                                  |
  # $B=*N;%?%0(B
  sed "s/\(<\/[a-zA-Z0-9][a-zA-Z0-9]*\)/${LF:?}\1${LF:?}/g" |
  # $B3+;O%?%0(B
  sed "s/\(<[a-zA-Z0-9][a-zA-Z0-9]*\)/${LF:?}\1${LF:?}/g"   | tee ts.1 |
  grep -E -e '(<|id="[^"]*"|class="[^"]*")'                 |
  ruby see-src.rb 
