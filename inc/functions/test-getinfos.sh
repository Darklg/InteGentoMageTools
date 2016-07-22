#!/bin/bash

###################################
## Test install & Get infos
###################################

if [ ! -f app/etc/local.xml ]; then
    echo "Only use import on installed Magento installations. (no local.xml)";
    . "${SOURCEDIR}/inc/functions/stop-magetools.sh";
fi;

. "${SOURCEDIR}/inc/functions/extract-infos.sh";

if ! mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id}"; then
    echo "Only use import on installed Magento installations. (no database connexion)";
    . "${SOURCEDIR}/inc/functions/stop-magetools.sh";
fi;

. "${SOURCEDIR}/inc/functions/test-magento-install.sh";
