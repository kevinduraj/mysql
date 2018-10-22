#!/bin/bash
#-----------------------------------------------------------------------------#
KEYWORD=$1
USERNAME="root"
DATABASE=''
#-----------------------------------------------------------------------------#
#                             Repair Tables
#-------------------------------------------------------------------------------------#
function table() {
  echo "$SQL" | mysql -u $USERNAME -p$PASSWORD -t -N | while read -r line
  do
    echo "$line"
  done
}
#-------------------------------------------------------------------------------------#

execute_shards()
{
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      echo -n "$(date +"%Y-%m-%d %H:%M")  "
      SQL="SELECT hit1, url FROM $DATABASE.$E WHERE MATCH (title,body) AGAINST('"$KEYWORD"') LIMIT 10;"
      echo " " $SQL
      table
      #RES=`mysql -u $USERNAME -p$PASSWORD -B -N -s -e "$SQL"`
      #echo $RES
      sleep 1 
  done
}
#-----------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-----------------------------------------------------------------------------#

mydb="engine37"

for DATABASE in $mydb
do  
    echo "Database: is [$db]"
    execute_shards 
done

#-----------------------------------------------------------------------------#
