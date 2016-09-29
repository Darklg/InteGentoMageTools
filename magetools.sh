#!/bin/bash

# Mage Tools v 0.22
#
# @author      Darklg <darklg.blog@gmail.com>
# @copyright   Copyright (c) 2016 Darklg
# @license     MIT

SCRIPTSTARTDIR="$( pwd )/";

###################################
## Looking for a Magento Install
###################################

ismagento='n';
SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
for (( c=1; c<=10; c++ )); do
    if [ ! -f "api.php" ]; then
        cd ..;
        echo ".";
        SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
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
    'settings')
        echo "## SETTINGS";
        . "${SOURCEDIR}/inc/functions/extract-infos.sh";
        . "${SOURCEDIR}/inc/functions/set-magento-settings.sh";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'permissions')
        echo "## Permissions";
        . "${SOURCEDIR}/inc/empty-cache.sh";
        . "${SOURCEDIR}/inc/functions/set-magento-permissions.sh";
    ;;
    'update')
        echo "## Update";
        . "${SOURCEDIR}/inc/update-module.sh" $2 $3;
    ;;
    'debug')
        echo "## Debug";
        . "${SOURCEDIR}/inc/debug.sh";
    ;;
    'help')
        echo "## HELP";
        . "${SOURCEDIR}/inc/help.sh";
    ;;
    'cache' | '')
        echo "## CACHE";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    *)
        echo "## ERROR";
        echo "- The command '${1}' does not exists !";
        echo '- Please try "magetools help" if you need a reminder.';
    ;;
esac

. "${SOURCEDIR}/inc/functions/clean-magetools.sh";
