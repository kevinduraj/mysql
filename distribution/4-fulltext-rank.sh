#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------------------------------#
USERNAME='root'
SOURCE_DB='engine31'
#----------------------------------------------------------------------------------------------------------------------------------------------#

TABLE_LIST=`mysql -uroot -p${PASS} -NB -e "SHOW TABLES FROM $SOURCE_DB"`

for E in $TABLE_LIST
do
    #------------------------------------------------------------------------------------#
    # SELECT MATCH('Content') AGAINST ('keyword1 keyword2') as Relevance FROM table WHERE MATCH ('Content') 
    # AGAINST('+keyword1 +keyword2' IN BOOLEAN MODE) HAVING Relevance > 0.2 ORDER BY Relevance DESC

    SQL="UPDATE $SOURCE_DB.$E SET rank = rank + (RAND() * 100) WHERE MATCH (title,body) AGAINST('government' IN BOOLEAN MODE);";
    echo "$SQL"
    res1=`mysql -uroot -p${PASS} -NB -e  "$SQL"`
    echo "$res1"

done

#----------------------------------------------------------------------------------------------------------------------------------------------#


