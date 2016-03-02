#!/bin/bash

###################################
## Test install & Get infos
###################################

. "${SOURCEDIR}/inc/functions/test-getinfos.sh";

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

###################################
## Default settings
###################################

. "${SOURCEDIR}/inc/functions/set-magento-settings.sh";

###################################
## Last test, to be sure.
###################################

. "${SOURCEDIR}/inc/functions/test-magento-install.sh";
