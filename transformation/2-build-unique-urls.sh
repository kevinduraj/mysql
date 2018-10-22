#!/bin/bash
#---------------------------------------------------------------------------------------#
SOURCE='engine50'
SORTED='temp2'
FINAL1='engine31'
START='000'
#---------------------------------------------------------------------------------------#
drop_table()
{
  SQL="DROP TABLE IF EXISTS $SORTED.part_$START"; echo $SQL
  res1=$(mysql -uroot -p${PASS} -e  "$SQL"); echo $res1
}
#---------------------------------------------------------------------------------------#
create_schema()
{
  SQL="CREATE DATABASE $SORTED DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  echo $SQL
  RES=`mysql -uroot -p${PASS} -NB -e "$SQL"`
  echo $RES
}
#---------------------------------------------------------------------------------------#
sort_tables()
{
  TABLE=$1
  SQL="CREATE TABLE $SORTED.$TABLE SELECT * FROM $SOURCE.$TABLE ORDER BY period DESC;"; echo "$SQL"
  RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`; echo "$RES"
}
#---------------------------------------------------------------------------------------#
#               INSERT LOW_PRIORITY INTO $FINAL1.$TABLE
#---------------------------------------------------------------------------------------#
latest_entry()
{
  TABLE=$1
  SQL="SET sql_mode = '';
        INSERT INTO $FINAL1.$TABLE
          SELECT DISTINCT (sha256url)
              ,md5root
              ,url
              ,root
              ,tags
              ,title
              ,body
              ,MIN(alexa)
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
            FROM $SORTED.$TABLE
            GROUP BY sha256url"

  echo "$SQL"; RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`; echo "$RES"
}
#---------------------------------------------------------------------------------------#
#                                Build Shard 
#---------------------------------------------------------------------------------------#
create_schema

  list=`echo {{0..9},{a..f}}`
  for one in $list; do
    for two in $list; do
      for three in $list; do

        shard="$one$two$three"
        let "hex = 0x$shard"
        let "start = 0x$START"
        if [ $hex -ge $start ]; then    
          echo $hex " " $shard
          echo $shard > last.log
    
          sort_tables "part_$shard"
          latest_entry "part_$shard"
        fi  

      done
    done
  done

#---------------------------------------------------------------------------------------#
