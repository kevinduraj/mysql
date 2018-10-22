SED Tools
=========

###Escape Single Quote
sed -i "s/'/\\\\\'/g" names.dat

###Delete Line containing text
sed -i '/+early/d;' names.dat

