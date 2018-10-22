#!/bin/bash
#---------------------------------------------------------------------------------------#
DATABASE='engine33'
START='000'

#---------------------------------------------------------------------------------------#
execute_sql() {

    TABLE=$1
      
    SQL="LOCK TABLES $DATABASE.$TABLE WRITE;

         DELETE FROM $DATABASE.$TABLE 
         WHERE   title LIKE '%myhealthcare%'
             OR  title LIKE '%nootrino%'
             OR  title LIKE '%find1friend%'
             OR  title LIKE '%pacificair%'
             OR  root  LIKE 'mam-kovovy-nabytek.cz'
             OR  root  LIKE 'leisurefayre.com';

         REPAIR TABLE $DATABASE.$TABLE;
         UNLOCK TABLES;"

    echo "$SQL"
    RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`; 
    echo "$RES"
    sleep 3
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
          execute_sql "part_$shard"
        fi  

      done
    done
  done

#---------------------------------------------------------------------------------------#
