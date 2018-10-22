#!/bin/bash
TABLE=$1
line=$2
MYSQL="mysql -uroot -p$PASS"

function table() {
  SQL=$1
  echo $SQL
  echo "$SQL" | $MYSQL -Bs | while read -r line
  do
    echo "$line"
  done

}

SQL="SELECT root, title, body FROM $TABLE WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE) ORDER BY RAND() LIMIT 1 \G"
table "$SQL"

# SQL="SELECT count(*) FROM $TABLE WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE);"
# echo $SQL
# total=$(echo "$SQL" | mysql -uroot -p$PASS -N)
# echo $total
