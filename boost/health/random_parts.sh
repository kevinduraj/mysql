#!/bin/sh
#------------------------------------------------------------------#
  list=`echo {{0..9},{a..f}}`
  for one in $list; do
    for two in $list; do
      for three in $list; do

        shard="$one$two$three"
        let "hex = 0x$shard"
        let "stop = 0xffa"
        #if [ $hex -gt $stop ]; then 
          # echo $hex " " $shard
          echo "part_$shard"
        #fi

      done
    done
  done

#------------------------------------------------------------------#

