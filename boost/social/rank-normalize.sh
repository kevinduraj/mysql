#!/bin/bash                                                                                                                                                                                                    
#---------------------------------------------------------------------------------#
#                             Repair Tables
#---------------------------------------------------------------------------------#
process_tables()
{
  USERNAME="root"
  DATABASE=$1

  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do  
      echo "$(date +"%Y-%m-%d %H:%M")"

      #--------------------------------------------------------------------------#
      SQL="UPDATE LOW_PRIORITY $DATABASE.$E SET rank = (RAND() * 400) + 200 WHERE rank > 200 AND rank < 500;"
      echo "$SQL"
      
      res1=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
      echo $res1
      
      sleep 3;

      #--------------------------------------------------------------------------#
      SQL="UPDATE LOW_PRIORITY $DATABASE.$E SET rank = (RAND() * 300) WHERE rank < 100;"
      echo "$SQL"
      
      res1=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
      echo $res1
      
      sleep 3;

      #--------------------------------------------------------------------------#
      SQL="UPDATE LOW_PRIORITY $DATABASE.$E SET rank = (RAND() * 300) + 500 WHERE rank > 700;"
      echo "$SQL"
      
      res1=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
      echo $res1

      sleep 3;
  done
}
#---------------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#---------------------------------------------------------------------------------#

#mydb="wbs engine1 engine3 engine5 engine7"
mydb="engine77"

for db in $mydb
do  
    echo "Database: is [$db]"
    process_tables $db 
done

#---------------------------------------------------------------------------------#
#     SQL="LOCK TABLES $DATABASE.$E WRITE;
#          REPAIR TABLE $DATABASE.$E;
#          OPTIMIZE TABLE $DATABASE.$E;
#          UNLOCK TABLES; "
#---------------------------------------------------------------------------------#
