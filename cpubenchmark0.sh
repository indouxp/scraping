#!/bin/sh
if [ ! -f cpubenchmark0.txt ]; then
  ruby cpubenchmark0.rb > cpubenchmark0.txt
fi
select=$1
shift
for i in "$@"
do
  select="${select}|$i"
done
  
select="${select}|Core i7 920 "
select="${select}|Phenom II X4 9[46]5"
select="${select}|Xeon E3-1230 @ 3.20GHz"
select="${select}|Core i5-2415M @ 2.30GHz"
egrep "(${select})" cpubenchmark0.txt | sort
