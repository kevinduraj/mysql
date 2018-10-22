#!/bin/bash

#rm -r temp/*
cqlsh -e "COPY cloud4.link2 (url) TO '/home/temp/june-link2.dat';"
ls -lh temp

