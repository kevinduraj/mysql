#!/bin/perl


$n = '9876543210';
#print"$n\n";

1 while ($n =~ s/^(-?\d+)(\d{3})/$1,$2/); print"$n\n";

