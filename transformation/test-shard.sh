#!/bin/bash
#---------------------------------------------------------------------------------------#
SOURCE='engine37'
DESTIN='engine38'
FINAL1='engine39'
#---------------------------------------------------------------------------------------#
move_tables()
{
  SQL="CREATE DATABASE $DESTIN DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  echo $SQL
  RES=`mysql -uroot -p$PASSWORD -NB -e "$SQL"`
  echo $RES

  TABLE_LIST=`mysql -uroot -p$PASSWORD -NB -e "show tables from $SOURCE"`
  for E in $TABLE_LIST
  do
      SQL="CREATE TABLE $DESTIN.$E SELECT * FROM $SOURCE.$E ORDER BY period DESC;"
      echo "$SQL"
      RES=`mysql -uroot -p$PASSWORD -NB -e  "$SQL"`
      echo "$RES"
  done
}
#---------------------------------------------------------------------------------------#
compute_tables()
{
  TABLE_LIST=`mysql -uroot -p$PASSWORD -NB -e "show tables from $DESTIN"`
  for E in $TABLE_LIST
  do

    SQL="INSERT LOW_PRIORITY INTO $FINAL1.$E
          SELECT DISTINCT (sha256url)
		      ,md5root
		      ,url
		      ,root
		      ,tags
		      ,title
		      ,body
		      ,MAX(alexa)
		      ,MAX(rank)
		      ,SUM(hit1)
		      ,SUM(hit2)
		      ,SUM(hit3)
		      ,category
		      ,period
		      ,AVG(gunning)
		      ,AVG(flesch)
		      ,AVG(kincaid)
		      ,AVG(sentence)
		      ,AVG(words)
		      ,AVG(syllables)
		      ,AVG(complex)

 	        FROM $DESTIN.$E 
 	        GROUP BY sha256url"

      echo "$SQL"
      RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
      echo "$RES"

  done

}
#---------------------------------------------------------------------------------------#
#             Repair and optimize all tables in the following databases
#---------------------------------------------------------------------------------------#

move_tables
#compute_tables

#---------------------------------------------------------------------------------------#

