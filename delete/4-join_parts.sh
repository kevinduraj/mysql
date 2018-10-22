#!/bin/bash
#-------------------------------------------#
for file in /home/temp/*
do

  echo $file
	cat $file >> url-old-deleted.dat

done
#-------------------------------------------#

