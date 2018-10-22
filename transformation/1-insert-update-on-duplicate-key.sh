#!/bin/bash
#------------------------------------------------------------------------------------#
USERNAME='root'
SOURCE_DB='engine33'
DESTINATION='engine31'
#------------------------------------------------------------------------------------#

TABLE_LIST=`mysql -uroot -p${PASS} -NB -e "SHOW TABLES FROM $DESTINATION"`

for E in $TABLE_LIST
do
SQL="INSERT INTO $DESTINATION.$E (sha256url,md5root,url,root,tags,title,body,period,gunning,flesch,kincaid,sentence,words,syllables,complex) 
        SELECT  sha256url,
                md5root,
                url,
                root,
                tags,
                title,
                body,
                period,
                gunning,
                flesch,
                kincaid,
                sentence,
                words,
                syllables,
                complex 
        FROM $SOURCE_DB.$E ON DUPLICATE KEY UPDATE 
                md5root=VALUES(md5root),
                url=VALUES(url),
                root=VALUES(root),
                tags=VALUES(tags),
                title=VALUES(title),
                body=VALUES(body),
                period=VALUES(period),
                gunning=VALUES(gunning),
                flesch=VALUES(flesch),
                kincaid=VALUES(kincaid),
                sentence=VALUES(sentence),
                words=VALUES(words),
                syllables=VALUES(syllables),
                complex=VALUES(complex);"

    echo "$SQL"
    res1=`mysql -uroot -p${PASS} -NB -e  "$SQL"`
    echo "$res1"
done

#------------------------------------------------------------------------------------#


