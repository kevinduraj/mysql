#!/bin/bash
#---------------------------------------------------------------------------------#
DATABASE="engine39"
MYSQL="mysql -h 69.13.39.34 -uroot -p$PASSWORD $DATABASE"
#---------------------------------------------------------------------------------#
echo "$(date +"%Y-%m-%d %H:%M") - $DATABASE"
#---------------------------------------------------------------------------------#
export_tables()
{
  TABLE_LIST=`mysql -h 69.13.39.34 -uroot -p$PASSWORD -NB -e "show tables from $DATABASE"`
  counter=1

  for E in $TABLE_LIST
  do
      #SQL="SELECT url FROM $DATABASE.$E INTO OUTFILE 'temp/${E}.dat';"
      SQL="SELECT url FROM $DATABASE.$E where root LIKE 'facebook.com';"
      echo $SQL

      #----------------------------------------------------#
      #              Multi Processing
      #----------------------------------------------------#

      echo "$SQL" | $MYSQL -N | while read -r line
      do
        echo "$line" >> temp/${E}.dat
        (( counter++ ))
      done
     
      echo "Exported: $counter"
      #----------------------------------------------------#

  done

  echo "Grand Total Exported: $counter"
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

