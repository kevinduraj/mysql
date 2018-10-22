#!/bin/bash                                                                                                                                                                            
#----------------------------------------------------------#
clear;
number=$(hexdump -vn "2" -e ' /1 "%02x"'  /dev/urandom)
random=${number:0:3}
engine='engine33'


  res1=$(openssl rand -hex 16)
  part=$(echo ${res1:7:3})
  SQL="SELECT root, title, body FROM $engine.part_$random LIMIT 1;"; 
  echo "$SQL"
  RES=` mysql -uroot -p${PASS} -e  "$SQL"`
  echo "$RES"

