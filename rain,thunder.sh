#!/bin/sh
# 東京電力 雨量・雷観測情報のデータの取得
# 東京都拡大のデータ(89)を取得し、雨量と雷雲落雷でファイル名を書き換える
# 01:雨量データ
# 04:雷雲＋落雷データ

mkdir /tmp/rain,thunder.d 2>/dev/null
if cd /tmp/rain,thunder.d; then
  for min in `awk 'BEGIN{for(i = 0; i < 120; i++) {printf("%d\n", i);}}'`
  do
    src="89_`date --date ${min:?}' min ago' +%d%H%M`.gif"

    dest=`echo ${src:?} | sed 's/89/01/'`
    if wget -t 3 -T 60 -w 2 -nc \
      "http://thunder.tepco.co.jp/wdata/1/${src:?}" 2>/dev/null; then
      mv ${src:?} ${dest:?}
    fi

    dest=`echo ${src:?} | sed 's/89/04/'`
    if wget -t 3 -T 60 -w 2 -nc \
      "http://thunder.tepco.co.jp/wdata/4/${src:?}" 2>/dev/null; then
      mv ${src:?} ${dest:?}
    fi
  done
fi

