#!/bin/bash                                                                                                                                                                            
#----------------------------------------------------------#
clear;
number=$(hexdump -vn "2" -e ' /1 "%02x"'  /dev/urandom)
random=${number:0:3}
engine='engine32'

if [ "$#" -eq 1 ]; then 

  res1=$(openssl rand -hex 16)
  part=$(echo ${res1:7:3})
  SQL="SELECT DISTINCT $1, COUNT($1) AS total FROM $engine.part_$random GROUP BY $1 ORDER BY $1;"; 
  echo "$SQL"
  RES=`nice mysql -uroot -p${PASS} -e  "$SQL"`
  echo "$RES"

else 
  echo "+----------------------------------+"
  echo "|     Parameters  1=field          |"
  echo "+----------------------------------+"
  echo "| ./0-distribution.sh rank         |"
  echo "+----------------------------------+"
  echo "| ./0-distribution.sh  hit1        |"
  echo "| ./0-distribution.sh  hit3        |"
  echo "| ./0-distribution.sh  rank        |"
  echo "| ./0-distribution.sh  root        |"
  echo "| ./0-distribution.sh  sentence    |"
  echo "| ./0-distribution.sh  complex     |"
  echo "+----------------------------------+"

fi

# +-----------+----------------------+------+-----+----------+-------+
# | Field     | Type                 | Null | Key | Default  | Extra |
# +-----------+----------------------+------+-----+----------+-------+
# | sha256url | char(64)             | NO   |     | NULL     |       |
# | md5root   | char(32)             | NO   |     | NULL     |       |
# | url       | varchar(255)         | NO   |     | NULL     |       |
# | root      | varchar(64)          | NO   |     | NULL     |       |
# | tags      | varchar(128)         | YES  |     | NULL     |       |
# | title     | varchar(128)         | YES  |     | NULL     |       |
# | body      | varchar(4096)        | YES  |     | NULL     |       |
# | alexa     | mediumint(6)         | YES  |     | NULL     |       |
# | rank      | mediumint(6)         | YES  |     | NULL     |       |
# | hit1      | mediumint(6)         | YES  |     | NULL     |       |
# | hit2      | mediumint(6)         | YES  |     | NULL     |       |
# | hit3      | mediumint(6)         | YES  |     | NULL     |       |
# | category  | char(3)              | YES  |     | NULL     |       |
# | period    | date                 | YES  |     | NULL     |       |
# | gunning   | float(5,2)           | NO   |     | 0.00     |       |
# | flesch    | float(5,2)           | NO   |     | 0.00     |       |
# | kincaid   | float(5,2)           | NO   |     | 0.00     |       |
# | sentence  | smallint(5) unsigned | NO   |     | 0        |       |
# | words     | float(5,2) unsigned  | NO   |     | 0.00     |       |
# | syllables | float(7,6) unsigned  | NO   |     | 0.000000 |       |
# | complex   | float(4,2) unsigned  | NO   |     | 0.00     |       |
# +-----------+----------------------+------+-----+----------+-------+

