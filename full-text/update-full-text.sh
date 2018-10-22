#!/bin/bash
#-----------------------------------------------------------------------------#
KEYWORD=$1
USERNAME="root"
DATABASE=''
#-------------------------------------------------------------------------------------#
#                             Repair Tables
#-------------------------------------------------------------------------------------#

execute_shards()
{
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      echo -n "$(date +"%Y-%m-%d %H:%M")  "
      SQL="UPDATE $DATABASE.$E SET hit1=hit1+1 WHERE MATCH (title,body) AGAINST('"$KEYWORD"');"
      echo " " $SQL
      RES=`mysql -u $USERNAME -p$PASSWORD -B -N -s -e "$SQL"`
      echo $RES
      sleep 1 
  done
}
#-------------------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-------------------------------------------------------------------------------------#

mydb="engine37"

for DATABASE in $mydb
do  
    echo "Database: is [$db]"
    execute_shards 
done

#-------------------------------------------------------------------------------------#
