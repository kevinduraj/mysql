#!/bin/bash
#---------------------------------------------------------------------------------------#
SOURCE='engine32'
FINAL1='engine83'
START='000'
ROOT='flvoters.com'

#---------------------------------------------------------------------------------------#
copy_table2table() {
  TABLE=$1

  SQL="INSERT IGNORE INTO $FINAL1.$TABLE SELECT * FROM $SOURCE.$TABLE WHERE root LIKE '$ROOT';"; echo "$SQL"
  RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`; echo "$RES"

  SQL="DELETE FROM $SOURCE.$TABLE WHERE root LIKE '$ROOT';"; echo "$SQL"
  RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`; echo "$RES"
}
#---------------------------------------------------------------------------------------#
#                                Build Shard 
#---------------------------------------------------------------------------------------#

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
          copy_table2table "part_$shard"
        fi  

      done
    done
  done

#---------------------------------------------------------------------------------------#
