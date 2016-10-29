#!/bin/bash

read -p "Start import ? [Y/n]: " start_import;
if [[ $start_import == 'n' ]]; then
    echo -e "${CLR_RED}Import cancelled.${CLR_DEF}";
    return;
fi;

###################################
## Test install & Get infos
###################################

if [ ! -f app/etc/local.xml ]; then
    echo -e "${CLR_RED}Only use import on installed Magento installations. (no local.xml)${CLR_DEF}";
    . "${SOURCEDIR}/inc/functions/stop-magetools.sh";
fi;

. "${SOURCEDIR}/inc/functions/extract-infos.sh";

###################################
## Search if import file
###################################

. "${SOURCEDIR}/inc/functions/search-import-file.sh";
if [[ $database_file_exists == '0' ]]; then
    echo -e "${CLR_RED}No import file has been found.${CLR_DEF}";
    . "${SOURCEDIR}/inc/functions/stop-magetools.sh";
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
