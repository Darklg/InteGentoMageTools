#!/bin/bash

read -p "Start install ? [Y/n]: " start_install;
if [[ $start_install == 'n' ]]; then
    echo "- Install cancelled.";
    return;
fi;

random_mysql_base=$(( ( RANDOM % 10000 )  + 1 ));

. "${SOURCEDIR}/inc/functions/add-default-files.sh";

###################################
## Set up local.xml
###################################

if [ ! -f app/etc/local.xml ]; then
    . "${SOURCEDIR}/inc/functions/ask-infos.sh";
else :
    . "${SOURCEDIR}/inc/functions/extract-infos.sh";
fi;

###################################
## DB
###################################

# Create database
create_database='n';
if [[ -z "`mysql --defaults-extra-file=my-magetools.cnf -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='${mysql_base}'" 2>&1`" ]]; then
    echo "- Database ${mysql_base} does not exist.";
    read -p "Create database ? [Y/n]: " create_database;
    if [[ $create_database != 'n' ]]; then
        . "${SOURCEDIR}/inc/functions/create-database.sh";
    fi;
fi;

# Import database if database creation
if [[ $create_database != 'n' ]]; then
    . "${SOURCEDIR}/inc/functions/search-import-file.sh";
    . "${SOURCEDIR}/inc/functions/import-database.sh";
fi;

if [[ -z "`mysql --defaults-extra-file=my-magetools.cnf -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='${mysql_base}'" 2>&1`" ]]; then
    echo "- Database '${mysql_base}' still does not exist.";
    . "${SOURCEDIR}/inc/functions/stop-magetools.sh";
else
    echo "- Database '${mysql_base}' does exist.";
    . "${SOURCEDIR}/inc/functions/test-magento-install.sh";
    . "${SOURCEDIR}/inc/functions/set-magento-settings.sh";
fi;

. "${SOURCEDIR}/inc/functions/set-magento-permissions.sh";
