#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------------------------------#
USERNAME='root'
SOURCE_DB='engine31'
DESTINATION='engine83'
#----------------------------------------------------------------------------------------------------------------------------------------------#

TABLE_LIST=`mysql -uroot -p${PASS} -NB -e "SHOW TABLES FROM $DESTINATION"`

for E in $TABLE_LIST
do
    #------------------------------------------------------------------------------------#
    SQL="UPDATE $SOURCE_DB.$E SET rank = 100 + (RAND() * 200) WHERE MATCH (title,body) AGAINST('linkedin' IN BOOLEAN MODE);";
    echo "$SQL"
    res1=`mysql -uroot -p${PASS} -NB -e  "$SQL"`
    echo "$res1"

    sleep 3;

    #------------------------------------------------------------------------------------#
    SQL="INSERT IGNORE $DESTINATION.$E (sha256url,md5root,url,root,tags,title,body,period,gunning,flesch,kincaid,sentence,words,syllables,complex)
        SELECT sha256url,md5root,url,root,tags,title,body,period,gunning,flesch,kincaid,sentence,words,syllables,complex 
        FROM $SOURCE_DB.$E
        WHERE MATCH (title,body) AGAINST('linkedin' IN BOOLEAN MODE);"

    echo "$SQL"
    res1=`mysql -uroot -p${PASS} -NB -e  "$SQL"`
    echo "$res1"

    sleep 1;

    #------------------------------------------------------------------------------------#
    SQL="DELETE LOW_PRIORITY FROM $SOURCE_DB.$E WHERE MATCH (title,body) AGAINST('linkedin' IN BOOLEAN MODE);"                                                                                                                
    echo $SQL
    RES=`mysql -uroot -p${PASS} -NB -e  "$SQL"`
    echo $RES
    
done

#----------------------------------------------------------------------------------------------------------------------------------------------#


