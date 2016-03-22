#!/bin/bash

# Mage Tools v 0.11
#
# @author      Darklg <darklg.blog@gmail.com>
# @copyright   Copyright (c) 2016 Darklg
# @license     MIT

SCRIPTSTARTDIR="$( pwd )/";

###################################
## Looking for a Magento Install
###################################

ismagento='n';
for (( c=1; c<=10; c++ )); do
    if [ ! -f "api.php" ]; then
        cd ..;
        echo ".";
        SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
        EXECDIR="$( cd "${SOURCEDIR}" && pwd )/";
    else
        if [ $c != 1 ]; then
            echo ". Found a Magento root dir";
        fi;
        ismagento='y';
        break;
    fi;
done

if [ $ismagento == 'n' ]; then
    cd ${SCRIPTSTARTDIR};
    echo "/!\ The script could not find a Magento root dir /!\\";
    return 0;
fi;

###################################
## Routing from initial argument
###################################

case "$1" in
    'install')
        echo "## INSTALL";
        . "${SOURCEDIR}/inc/install.sh";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'import')
        echo "## IMPORT";
        . "${SOURCEDIR}/inc/import.sh";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'permissions')
        echo "## Permissions";
        . "${SOURCEDIR}/inc/empty-cache.sh";
        . "${SOURCEDIR}/inc/functions/set-magento-permissions.sh";
    ;;
    'debug')
        echo "## Debug";
        . "${SOURCEDIR}/inc/debug.sh";
    ;;
    'cache' | *)
        echo "## CACHE";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
esac


