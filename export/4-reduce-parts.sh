#!/bin/bash
#-------------------------------------------#
for file in /home/temp/data/*
do

  echo $file
	cat $file >> /home/temp/visited_37.dat

done
#-------------------------------------------#

