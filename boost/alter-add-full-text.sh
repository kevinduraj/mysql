#!/bin/bash
#-----------------------------------------------------------------------------#
DATABASE='engine31'
#-----------------------------------------------------------------------------#
#                             Repair Tables
#-----------------------------------------------------------------------------#
index_tables()
{

  TABLE_LIST=`mysql -uroot -p$PASS -NB -e "SHOW TABLES FROM $DATABASE"`

  for E in $TABLE_LIST
  do
      echo -n "$(date +"%Y-%m-%d %H:%M") "
      echo "ALTER TABLE $DATABASE.$E ADD FULLTEXT INDEX title_body (title,body);"

      SQL="LOCK TABLES $DATABASE.$E WRITE;
           ALTER TABLE $DATABASE.$E ADD FULLTEXT INDEX title_body (title,body);
           UNLOCK TABLES;"

      RES=`mysql -uroot -p$PASS -NB -e  "$SQL"`
      echo $RES
  done
}
#-----------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-----------------------------------------------------------------------------#

index_tables 

#-----------------------------------------------------------------------------#
