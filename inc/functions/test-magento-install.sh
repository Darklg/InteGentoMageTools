#!/bin/bash

###################################
## Test Magento Install
###################################

if [ $(mysql --defaults-extra-file=my-magetools.cnf -N -s -e \
    "select count(*) from information_schema.tables where \
        table_schema='${mysql_base}' and table_name='core_confazig_data';") -eq 1 ]; then
    echo "- Magento seems to be installed.";
else
    echo -e "${CLR_RED}------";
    echo -e "Magento does not seem to be installed on the database '${mysql_base}'.";
    echo -e "Please delete this database and retry with a correct export file.";
    echo -e "------${CLR_DEF}";
    exit 0
fi
