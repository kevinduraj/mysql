#!/bin/bash
#-----------------------------------------------------------------------------------------------------------------------#
DATABASE='engine32'
START='000'
#-----------------------------------------------------------------------------------------------------------------------#
execute_sql() {

    TABLE=$1
    #---------------------------------------------------------------------------------------------------------#
    # SQL="UPDATE $DATABASE.$E SET rank = 100 + (RAND() * 300);";
    # SQL="UPDATE $DATABASE.$E SET rank = gunning WHERE rank IS NULL;";
    # SQL="UPDATE $DATABASE.$E SET rank = RAND() * 100 WHERE root LIKE 'twitter.com'; ";
    # SQL="UPDATE $DATABASE.$E SET rank = rank + (RAND() * 100) WHERE url LIKE '%wiki%';";
    # SQL="UPDATE $DATABASE.$E SET rank = rank + (RAND() * 200) WHERE complex > 10 AND complex < 30;";
    # SQL="UPDATE $DATABASE.$E SET rank = rank + sentence WHERE sentence < 75;";
    # SQL="UPDATE LOW_PRIORITY $DATABASE.$TABLE SET rank = 400 + (RAND() * 100) WHERE rank > 500;";
    # SQL="UPDATE LOW_PRIORITY $DATABASE.$TABLE SET rank = rank + (RAND() * 100) WHERE url LIKE '%wiki%';";
    # SQL="UPDATE LOW_PRIORITY $DATABASE.$TABLE SET rank = rank + (RAND() * 200) WHERE url LIKE '%bitcoin%';";
    SQL="UPDATE LOW_PRIORITY $DATABASE.$TABLE SET rank = 450 + (RAND() * 50) WHERE root LIKE '%nih.gov%';";
    #----------------------------------------------------------------------------------------------------------#

    echo "$SQL"
    RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`; 
    echo "$RES"
}
#-----------------------------------------------------------------------------------------------------------------------#
#                                Build Shard 
#-----------------------------------------------------------------------------------------------------------------------#

list=`echo {{0..9},{a..f}}`
for one in $list; do
  for two in $list; do
    for three in $list; do

      shard="$one$two$three"
      let "hex = 0x$shard"
      let "start = 0x$START"
      if [ $hex -ge $start ]; then    
        echo "part_$shard"; sleep 1;
        echo $shard > last.log
        execute_sql "part_$shard"
      fi  

    done
  done
done

#-----------------------------------------------------------------------------------------------------------------------#

