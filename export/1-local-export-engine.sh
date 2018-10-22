#!/bin/bash
#---------------------------------------------------------------------------------#
USERNAME='root'
DATABASE='engine35'
PROCESS=4
echo "$(date +"%Y-%m-%d %H:%M") - $DATABASE"
#---------------------------------------------------------------------------------#
export_tables()
{
  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`
  counter=1

  for E in $TABLE_LIST
  do
      SQL="SELECT url FROM $DATABASE.$E INTO OUTFILE '/home/big/data/${E}.dat';"
      echo $SQL

      #----------------------------------------------------#
      #              Multi Processing
      #----------------------------------------------------#
      isEvenNo=$( expr $counter % ${PROCESS} )

      if [ $isEvenNo -ne 0 ]
      then
          # Background run 
          echo "Back: " "$SQL" 
          mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL" &
      else
          # Foreground run
          echo "Front:" "$SQL"
          RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`
          echo "$RES"
      fi
      (( counter++ ))
      #----------------------------------------------------#

      sleep 1;
  done
}

#---------------------------------------------------------------------------------#
#---    Repair and optimize all tables in the following databases
#---------------------------------------------------------------------------------#

for db in $DATABASE
do  
    echo "Database: is [$db]"
    export_tables $db
done

#---------------------------------------------------------------------------------#

