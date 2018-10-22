#!/bin/bash
DATABASE='engine39'
#-----------------------------------------------------------------------------#
#                             Repair Tables
#-----------------------------------------------------------------------------#
index_tables()
{

  TABLE_LIST=`mysql -u root -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      echo -n "$(date +"%Y-%m-%d %H:%M") "
      echo " ALTER TABLE $DATABASE.$E ADD FULLTEXT INDEX title_body (title,body);"

      SQL="LOCK TABLES $DATABASE.$E WRITE;
           ALTER TABLE $DATABASE.$E ADD FULLTEXT INDEX title_body (title,body);
           UNLOCK TABLES;"

      RES=`mysql -u root -p$PASSWORD -NB -e  "$SQL"`
      echo $RES
      sleep 3
  done
}
#-----------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-----------------------------------------------------------------------------#

index_tables 

#-----------------------------------------------------------------------------#
