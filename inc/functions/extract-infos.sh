#!/bin/bash

###################################
## Default files
###################################

echo "-- Extracting values from local.xml";
datalocal=`cat app/etc/local.xml`;
mysql_base=$(sed -ne '/dbname/{s/.*<dbname><\!\[CDATA\[\(.*\)\]\]><\/dbname>.*/\1/p;q;}' <<< "$datalocal");
echo -e "- MySQL base is : ${CLR_GREEN}${mysql_base}${CLR_DEF}.";
mysql_user=$(sed -ne '/username/{s/.*<username><\!\[CDATA\[\(.*\)\]\]><\/username>.*/\1/p;q;}' <<< "$datalocal");
echo -e "- MySQL user is : ${CLR_GREEN}${mysql_user}${CLR_DEF}.";
mysql_pass=$(sed -ne '/password/{s/.*<password><\!\[CDATA\[\(.*\)\]\]><\/password>.*/\1/p;q;}' <<< "$datalocal");
echo -e "- MySQL pass is : ${CLR_GREEN}${mysql_pass}${CLR_DEF}.";

# Cache config
. "${SOURCEDIR}/inc/functions/set-mysql-file.sh";
