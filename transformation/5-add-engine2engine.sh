#!/bin/bash
#------------------------------------------------------------------------------------#
# mysql_config_editor set --login-path=local --host=localhost --user=root --password
#------------------------------------------------------------------------------------#
USERNAME='root'
DATABASES='engine32'
DESTINATION='engine33'
#------------------------------------------------------------------------------------#

for DATABASE in $DATABASES
do  
  TABLE_LIST=`mysql -uroot -pxapian64 -NB -e "SHOW TABLES FROM $DATABASE"`

  for E in $TABLE_LIST
  do
      SQL="INSERT LOW_PRIORITY IGNORE INTO $DESTINATION.$E SELECT * FROM $DATABASE.$E "
      echo "$SQL"
      res1=`mysql -uroot -pxapian64 -NB -e  "$SQL"`
      echo "$res1"
      sleep 1
  done
done

#------------------------------------------------------------------------------------#


