#!/bin/bash
#--------------------------------------------------------------------------------------#
# python = int("b5f", 15)
# gosleep=$((gosleep+2)) 
#--------------------------------------------------------------------------------------#
alter_tables()
{
  DATABASE=$1
  TABLE_LIST=`mysql -uroot -p${PASS} -NB -e "SHOW TABLES FROM $DATABASE"`
  counter=0; gosleep=0; last=0;

  for E in $TABLE_LIST
  do
    proc=`mysqladmin -uroot -p${PASS}  processlist | wc | awk '{ print $1 }'`

    #----------------------------------#
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
   

    #-----------------------------------------------------------------------------------------------------------------------#
    # SQL="ALTER TABLE $DATABASE.$E CHANGE md5url sha256url CHAR(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL;"
    # SQL="ALTER TABLE $DATABASE.$E CHANGE hits hits MEDIUMINT(6) NULL DEFAULT NULL;"
    # SQL="UPDATE $DATABASE.$E SET rank = RAND() * 100 WHERE root LIKE 'twitter.com'; ";
    # SQL="UPDATE $DATABASE.$E SET rank = 100 + (RAND() * 300);";
    # SQL="UPDATE $DATABASE.$E SET rank = 300 + (RAND() * 200) WHERE root LIKE 'facebook.com';";
    # SQL="UPDATE $DATABASE.$E SET rank = gunning WHERE rank IS NULL;";
    # SQL="UPDATE $DATABASE.$E SET rank = rank + (RAND() * 200) WHERE complex > 10 AND complex < 30;";
    # SQL="UPDATE $DATABASE.$E SET rank = rank + sentence WHERE sentence < 75;";
    SQL="UPDATE $DATABASE.$E SET rank = rank + (RAND() * 100) WHERE url LIKE '%wiki%';";
    #-----------------------------------------------------------------------------------------------------------------------#

    echo "$SQL"; 
    sleep 1;
    nohup mysql -uroot -p${PASS} -NB -e  "$SQL" &
        
    #---------------------------------------------------------------------------------------------------------------------#
    last=$proc
    sleep $gosleep      
    ((counter++))

  done
}
#--------------------------------------------------------------------------------------#
#         Repair and optimize all tables in the following databases
#--------------------------------------------------------------------------------------#
mydb="engine31"
for db in $mydb
do  
    echo "Database: is [$db]"
    alter_tables $db
done
#--------------------------------------------------------------------------------------#

