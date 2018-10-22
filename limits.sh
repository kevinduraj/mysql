#!/bin/bash

cat /proc/$(pgrep mysqld$)/limits 
