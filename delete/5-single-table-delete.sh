#!/bin/bash
#---------------------------------------------------------------------------------------#
SOURCE='engine33'
START='000'

#---------------------------------------------------------------------------------------#
delete_from_tables() {
  TABLE=$1

  SQL="DELETE FROM $SOURCE.$TABLE WHERE complex > 80;"; echo "$SQL"
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
          delete_from_tables "part_$shard"
        fi  

      done
    done
  done

#---------------------------------------------------------------------------------------#
