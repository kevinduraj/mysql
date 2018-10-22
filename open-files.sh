#!/usr/bin/bash

echo "SHOW GLOBAL variables LIKE '%limit%'" | mysql -uroot -p${PASS} -t -N | while read -r line
do
    echo "$line"
done

echo "show status like 'open%'" | mysql -uroot -p${PASS} -t -N | while read -r line
do
    echo "$line"
done


echo "show status like 'max_connections'" | mysql -uroot -p${PASS} -t -N | while read -r line
do
    echo "$line"
done
