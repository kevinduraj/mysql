#!/bin/bash
#-----------------------------------------------------------------------------#
#                             Repair Tables
#-----------------------------------------------------------------------------#
repair_tables()
{
  USERNAME="root"
  DATABASE=$1

  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      echo -n "$(date +"%Y-%m-%d %H:%M") "$DATABASE"."$E
      SQL="ALTER TABLE $DATABASE.$E DROP INDEX body_index;"
      echo " " $SQL
      RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
      echo $RES
      sleep 1
  done
}
#-----------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-----------------------------------------------------------------------------#

#mydb="wbs engine1 engine3 engine5 engine7"
mydb="engine37"

for db in $mydb
do  
    echo "Database: is [$db]"
    repair_tables $db
done

#-----------------------------------------------------------------------------#
