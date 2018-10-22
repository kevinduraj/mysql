#!/bin/bash

sort -S 16G --parallel=6 -uR temp/link.dat | tee temp/link.sort >> /dev/null 2>&1
