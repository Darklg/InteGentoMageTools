#!/bin/bash

###################################
## Test install & Get infos
###################################

if [ ! -f app/etc/local.xml ]; then
    echo "Only use import on installed Magento installations. (no local.xml)";
    exit 1;
fi;

. "${SOURCEDIR}/inc/functions/extract-infos.sh";

if ! mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id}"; then
    echo "Only use import on installed Magento installations. (no database connexion)";
    exit 1;
fi;

###################################
## Search if import file
###################################

. "${SOURCEDIR}/inc/functions/search-import-file.sh";
if [[ $database_file_exists == '0' ]]; then
    echo "No import file has been found.";
    exit 1;
fi;

###################################
## Launch import
###################################

. "${SOURCEDIR}/inc/functions/delete-database.sh";
. "${SOURCEDIR}/inc/functions/create-database.sh";
. "${SOURCEDIR}/inc/functions/import-database.sh";

