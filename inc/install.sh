#!/bin/bash

random_project_id=$(( ( RANDOM % 10000 )  + 1 ));

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
if ! mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id}"; then
    echo "- Database ${project_id} does not exist.";
    read -p "Create database ? [Y/n]:" create_database;
    if [[ $create_database != 'n' ]]; then
        . "${SOURCEDIR}/inc/functions/create-database.sh";
    fi;
fi;

# Import database if database creation
if [[ $create_database != 'n' ]]; then
    . "${SOURCEDIR}/inc/functions/search-import-file.sh";
    . "${SOURCEDIR}/inc/functions/import-database.sh";
fi;

if ! mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id}"; then
    echo "- Database '${project_id}' still does not exist.";
    exit 1;
else
    echo "- Database '${project_id}' does exist.";
    . "${SOURCEDIR}/inc/functions/test-magento-install.sh";
    . "${SOURCEDIR}/inc/functions/set-magento-settings.sh";
fi

. "${SOURCEDIR}/inc/functions/set-magento-permissions.sh";
