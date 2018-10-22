#!/bin/sh
#-----------------------------------------------------------------------------------------#
USERNAME='root'
DB='engine39'
file_source='names.dat';
total=""
START='005'
#-----------------------------------------------------------------------------------------#
exec_sql()
{
  SQL=$1
  RES=`mysql -u $USERNAME -p$PASSWORD -NB -e "$SQL"`
}
#-----------------------------------------------------------------------------------------#
# https://dev.mysql.com/doc/refman/5.5/en/fulltext-natural-language.html
# IN NATURAL LANGUAGE MODE
# IN BOOLEAN MODE
#-----------------------------------------------------------------------------------------#
execute_build_sql()
{
  TABLE=$DB'.'$1
 
  #BOOST=$(( ( RANDOM % 5 ) + 3 ))
  SQL="SELECT count(*) FROM $TABLE WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE);"
  total=$(echo "$SQL" | mysql -u $USERNAME -p$PASSWORD -N) 
 
  # Compute hit3 rank only if result is not 0 
  if [[ "$total" != 0 ]] ; then 
    printf '%5s' $total' '
    total2=$(echo "7-l($total)" | bc -l)
    int=${total2%.*}

    if [ "$int" ];then 
      SQL="UPDATE LOW_PRIORITY $TABLE SET hit3=hit3+$int WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE);"
      echo "$SQL"; exec_sql "$SQL"
    else 
      SQL="IGNORE LOW_PRIORITY $TABLE SET hit3=hit3+$int WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE);"
      echo "$SQL"; 
    fi 
  fi

}
#----------------------------------------------------------------------------------------#
random_partitions()
{
    while IFS='' read -r part1 || [[ -n "$part1" ]]; do
    
        while IFS='' read -r line || [[ -n "$line" ]]; do
        execute_build_sql $part1
        done < $file_source 
    
    done < "parts.dat"
}
#----------------------------------------------------------------------------------------#
#                                Build Shard 
#----------------------------------------------------------------------------------------#
  list=`echo {{0..9},{a..f}}`
  for one in $list; do
    for two in $list; do
      for three in $list; do

        shard="$one$two$three"
        let "hex = 0x$shard"
        let "start = 0x$START"
        if [ $hex -ge $start ]; then    
          echo $shard > last.log
    
          while IFS='' read -r line || [[ -n "$line" ]]; do
          execute_build_sql  "part_$shard"
          done < $file_source 


        fi  

      done
    done
  done

#---------------------------------------------------------------------------------------#

