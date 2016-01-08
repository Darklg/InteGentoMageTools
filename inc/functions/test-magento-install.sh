#!/bin/bash

###################################
## Test Magento Install
###################################

if [ $(mysql -N -s -u ${mysql_user} -p${mysql_pass} -e \
    "select count(*) from information_schema.tables where \
        table_schema='${project_id}' and table_name='core_config_data';") -eq 1 ]; then
    echo "- Magento seems to be installed.";
else
    echo "------";
    echo "Magento does not seem to be installed on the database '${project_id}'.";
    echo "Please delete this database and retry with a correct export file.";
    echo "------";
    exit 0
fi
