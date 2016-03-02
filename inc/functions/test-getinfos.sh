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

. "${SOURCEDIR}/inc/functions/test-magento-install.sh";
