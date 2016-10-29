#!/bin/bash

###################################
## Test install & Get infos
###################################

if [ ! -f app/etc/local.xml ]; then
    echo "${CLR_RED}Only use import on installed Magento installations. (no local.xml)${CLR_DEF}";
    . "${SOURCEDIR}/inc/functions/stop-magetools.sh";
fi;

. "${SOURCEDIR}/inc/functions/extract-infos.sh";

if ! mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base}"; then
    echo "${CLR_RED}Only use import on installed Magento installations. (no database connexion)${CLR_DEF}";
    . "${SOURCEDIR}/inc/functions/stop-magetools.sh";
fi;

. "${SOURCEDIR}/inc/functions/test-magento-install.sh";
