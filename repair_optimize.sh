#!/bin/bash
#------------------------------------------------------------------------------------#
# mysql_config_editor set --login-path=local --host=localhost --user=root --password
#------------------------------------------------------------------------------------#
repair_tables() {
  DATABASE=$1

  TABLE_LIST=`mysql -uroot -p${PASS} -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      SQL="LOCK TABLES $DATABASE.$E WRITE;
           REPAIR TABLE $DATABASE.$E;
           OPTIMIZE TABLE $DATABASE.$E;
           UNLOCK TABLES; "

      echo $SQL
      RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`
      echo $RES
  done
}

#------------------------------------------------------------------------------------#
#           Repair and optimize all tables in the following databases
#------------------------------------------------------------------------------------#
mydb="engine50"

for db in $mydb
do  
    echo "Database: is [$db]"
    repair_tables $db
done

#------------------------------------------------------------------------------------#
