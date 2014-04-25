#!/bin/sh
if [ ! -f cpubenchmark0.txt ]; then
  ruby cpubenchmark0.rb > cpubenchmark0.txt
fi
select="Core i7 920 "
select="${select}|Phenom II X4 9[46]5"
select="${select}|Xeon E3-1230 @ 3.20GHz"
select="${select}|Core i5-2415M @ 2.30GHz"
select="${select}|Core i7-2677M @ 1.80GHz"
select="${select}|Core2 Duo T8300"
select="${select}|Athlon 64 X2 Dual Core 6000+"
select="${select}|Core Solo T1300"
select="${select}|Core2 Duo U9400"

if [ "$#" -ne "0" ]; then
  for i in "$@"
  do
    select="${select}|$i"
  done
fi
  
egrep "(${select})" cpubenchmark0.txt | sort
