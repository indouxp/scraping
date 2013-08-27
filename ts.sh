#!/bin/sh


#egrep '(この請求明細における新規料金合計|この期間にはあなたの実績はありません。|>詳細<|>概略<)' ts.[1-4]

egrep 'id="account_activity_table_tab_content"' ts.[1-4]
