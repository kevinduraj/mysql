#!/usr/bin/bash
#-----------------------------------------------------------------------------------------#
USERNAME='root'
DB='engine32'
file_source='keywords_health.dat';
total=""
START='000'
#-----------------------------------------------------------------------------------------#
exec_sql()
{
  SQL=$1
  #RES=`mysql -u $USERNAME -p$PASS -NB -e "$SQL"`
  echo "$SQL"; sleep 1
  mysql -uroot -p${PASS} -NB -e  "$SQL" &
}
#-----------------------------------------------------------------------------------------#
# https://dev.mysql.com/doc/refman/5.5/en/fulltext-natural-language.html
# IN NATURAL LANGUAGE MODE
# IN BOOLEAN MODE
#-----------------------------------------------------------------------------------------#
execute_build_sql()
{
    TABLE=$DB'.'$1
    line=$2

    #BOOST=$(( ( RANDOM % 5 ) + 3 ))

    #-----------------------------------------------------------------------------------------------#
    SQL="SELECT count(*) FROM $TABLE WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE);"
    total=$(echo "$SQL" | mysql -u $USERNAME -p$PASS -N) 
    
    if [[ "$total" != 0 ]] ; then 
         printf '%5s' $total' '
         total2=$(echo "10 - l($total)" | bc -l)
         int=${total2%.*}
         
         if [ "$int" ];then 
            SQL="UPDATE LOW_PRIORITY $TABLE SET rank=rank+$int, hit1=hit1+$int WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE);"
            echo "$SQL"; exec_sql "$SQL"
         else 
            SQL="IGNORE LOW_PRIORITY $TABLE SET rank=rank+$int, hit1=hit1+$int WHERE MATCH (title,body) AGAINST('"$line"' IN BOOLEAN MODE);"
            echo "$SQL"; 
         fi 
    fi
    #-----------------------------------------------------------------------------------------------#

}
#----------------------------------------------------------------------------------------#
random_partitions()
{

    while IFS='' read -r line || [[ -n "$line" ]]; do
        sleep 1
        while IFS='' read -r part1 || [[ -n "$part1" ]]; do
        sleep 1
    
                 #----------------------------------#
                 proc=`mysqladmin -uroot -p${PASS}  processlist | wc | awk '{ print $1 }'`
                 echo "proc=$proc"
                 if [ "$proc" -lt "8" ]; then
                 	gosleep=0
                 else
                 	if [ "$proc" -lt "$last" ]; then
                 		((gosleep--))
                 	else
                 		((gosleep++))
                 	fi
                 fi
                 #----------------------------------#

                execute_build_sql $part1 "$line" &
                #execute_build_sql  "part_$shard"

                last=$proc
                echo "gosleep=$gosleep"
                sleep $gosleep      
                ((counter++))

        sleep 1
        done < "parts.dat"
        sleep 1
    done < $file_source 
}
#----------------------------------------------------------------------------------------#

random_partitions

#---------------------------------------------------------------------------------------#

