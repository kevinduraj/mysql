#!/bin/bash

number=$(hexdump -vn "2" -e ' /1 "%02x"'  /dev/urandom)
random=${number:0:3}
echo $random
