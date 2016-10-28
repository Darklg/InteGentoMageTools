#!/bin/bash

###################################
## Default files
###################################

echo "-- Extracting values from local.xml";
datalocal=`cat app/etc/local.xml`;
mysql_base=$(sed -ne '/dbname/{s/.*<dbname><\!\[CDATA\[\(.*\)\]\]><\/dbname>.*/\1/p;q;}' <<< "$datalocal");
echo "- MySQL base is : '${mysql_base}'.";
mysql_user=$(sed -ne '/username/{s/.*<username><\!\[CDATA\[\(.*\)\]\]><\/username>.*/\1/p;q;}' <<< "$datalocal");
echo "- MySQL user is : '${mysql_user}'.";
mysql_pass=$(sed -ne '/password/{s/.*<password><\!\[CDATA\[\(.*\)\]\]><\/password>.*/\1/p;q;}' <<< "$datalocal");
echo "- MySQL pass is : '${mysql_pass}'.";

# Cache config
. "${SOURCEDIR}/inc/functions/set-mysql-file.sh";
