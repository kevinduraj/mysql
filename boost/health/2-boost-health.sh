#!/bin/bash -x
#--------------------------------------------------------------------------------------#
# python = int("b5f", 15)
# gosleep=$((gosleep+2)) 
#--------------------------------------------------------------------------------------#
DATABASE='engine32'
file_source='keywords_health.dat';
#--------------------------------------------------------------------------------------#
alter_tables()
{
  TERM="conex with codeine"
  TABLE_LIST=`mysql -uroot -p${PASS} -NB -e "SHOW TABLES FROM $DATABASE"`
  counter=0; gosleep=0; last=0;

  for E in $TABLE_LIST
  do

    #----------------------------------#
    proc=`mysqladmin -uroot -p${PASS}  processlist | wc | awk '{ print $1 }'`
    if [ "$proc" -lt "10" ]; then
    	gosleep=0
    else
    	if [ "$proc" -lt "$last" ]; then
    		((gosleep--))
    	else
    		((gosleep++))
    	fi
    fi
    #----------------------------------#
   
    #---------------------------------------------------------------------------------------------------------------------#
    SQL="SELECT count(*) FROM $TABLE WHERE MATCH (title,body) AGAINST('"$TERM"' IN BOOLEAN MODE);"
    echo "TERM=$TERM"
    total=$(echo "$SQL" | mysql -u $USERNAME -p$PASS -N) 
    echo "total=$total"

    # Compute hit1 rank only if result is not 0 
    #if [[ "$total" != 0 ]] ; then 
    #     printf '%5s' $total' '
    #     total2=$(echo "10 - l($total)" | bc -l)
    #     int=${total2%.*}
    #     
    #     if [ "$int" ];then 
    #        SQL="UPDATE LOW_PRIORITY $TABLE SET rank=rank+$int, hit1=hit1+$int WHERE MATCH (title,body) AGAINST('$TERM' IN BOOLEAN MODE);"
    #        echo "$SQL"; sleep 0.1
    #        #nohup mysql -uroot -p${PASS} -NB -e  "$SQL" &
    #        mysql -uroot -p${PASS} -NB -e  "$SQL" &

    #     else 
    #        SQL="IGNORE LOW_PRIORITY $TABLE SET rank=rank+$int, hit1=hit1+$int WHERE MATCH (title,body) AGAINST('$TERM' IN BOOLEAN MODE);"
    #        echo "$SQL"; 
    #     fi 
    #fi
    #---------------------------------------------------------------------------------------------------------------------#
        
    #---------------------------------------------------------------------------------------------------------------------#
    last=$proc
    sleep $gosleep      
    ((counter++))
    sleep 1

  done
}
#--------------------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#--------------------------------------------------------------------------------------#

#while IFS='' read -r line || [[ -n "$line" ]]; do

    alter_tables $line  

#done < $file_source 



#--------------------------------------------------------------------------------------#

