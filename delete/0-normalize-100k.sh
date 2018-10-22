#!/bin/bash
#-----------------------------------------------------------------------------#
mydb="engine33"
LEFT=100000
#-----------------------------------------------------------------------------#
repair_tables()
{
  USERNAME='root'
  DATABASE=$1

  TABLE_LIST=`mysql -u $USERNAME -p$PASSWORD -NB -e "show tables from $DATABASE"`

  for E in $TABLE_LIST
  do
      echo "$(date +"%Y-%m-%d %H:%M") TABLE = "$DATABASE"."$E
      SQL="SELECT count(*) FROM  $DATABASE.$E;"; echo $SQL
      QTY=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`; 
      
      echo -n "TOTAL: " $QTY
      TOTAL=$(expr $QTY - $LEFT)
      echo "    DELETE: " $TOTAL
   
      if [ $TOTAL -gt 1 ]
      then
        # SQL="SELECT url FROM $DATABASE.$E ORDER BY period LIMIT $TOTAL INTO OUTFILE '/home/temp/${E}.dat';"
        # echo $SQL
        # RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`; echo $RES
        # sleep 1

        SQL="DELETE FROM $DATABASE.$E ORDER BY period LIMIT $TOTAL;"; echo $SQL
        RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`; echo $RES
        sleep 3

      fi

      SQL="OPTIMIZE TABLE $DATABASE.$E;"; echo $SQL
      RES=`mysql -u $USERNAME -p$PASSWORD -NB -e  "$SQL"`; echo $RES
      sleep 3

  done
}
#-----------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#-----------------------------------------------------------------------------#
for db in $mydb
do  
    echo "Database: is [$db]"
    repair_tables $db
done
#-----------------------------------------------------------------------------#
