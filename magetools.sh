#!/bin/bash

# Mage Tools v 0.34
#
# @author      Darklg <darklg.blog@gmail.com>
# @copyright   Copyright (c) 2016 Darklg
# @license     MIT

CLR_BLUE='\033[34m'; # SECTION
CLR_GREEN='\033[32m'; # MESSAGE
CLR_YELLOW='\033[33m'; # INFO
CLR_RED='\033[31m'; # MESSAGE
CLR_DEF='\033[0m'; # RESET

SCRIPTSTARTDIR="$( pwd )/";

###################################
## Looking for a Magento Install
###################################

ismagento='n';
SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
for (( c=1; c<=10; c++ )); do
    if [ ! -d "app" ]; then
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

. "${SOURCEDIR}/inc/helpers.sh";
case "$1" in
    'install')
        echo -e "${CLR_BLUE}## INSTALL${CLR_DEF}";
        . "${SOURCEDIR}/inc/install.sh";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'import')
        echo -e "${CLR_BLUE}## IMPORT${CLR_DEF}";
        . "${SOURCEDIR}/inc/import.sh";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'settings')
        echo -e "${CLR_BLUE}## SETTINGS${CLR_DEF}";
        . "${SOURCEDIR}/inc/functions/extract-infos.sh";
        . "${SOURCEDIR}/inc/functions/set-magento-settings.sh";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'permissions')
        echo -e "${CLR_BLUE}## Permissions${CLR_DEF}";
        . "${SOURCEDIR}/inc/empty-cache.sh";
        . "${SOURCEDIR}/inc/functions/set-magento-permissions.sh";
    ;;
    'update')
        echo -e "${CLR_BLUE}## Update${CLR_DEF}";
        . "${SOURCEDIR}/inc/update-module.sh" $2 $3;
    ;;
    'sample')
        echo -e "${CLR_BLUE}## Sample${CLR_DEF}";
        . "${SOURCEDIR}/inc/sample.sh" $2 $3;
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'debug')
        echo -e "${CLR_BLUE}## Debug${CLR_DEF}";
        . "${SOURCEDIR}/inc/debug.sh";
    ;;
    'help')
        echo -e "${CLR_BLUE}## HELP${CLR_DEF}";
        . "${SOURCEDIR}/inc/help.sh";
    ;;
    'copy' | 'cp')
        echo -e "${CLR_BLUE}## COPY${CLR_DEF}";
        . "${SOURCEDIR}/inc/copy.sh" $2;
    ;;
    'cache' | '')
        echo -e "${CLR_BLUE}## CACHE${CLR_DEF}";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    *)
        echo -e "${CLR_BLUE}## ERROR${CLR_DEF}";
        echo "- The command '${1}' does not exists !";
        echo '- Please try "magetools help" if you need a reminder.';
    ;;
esac

. "${SOURCEDIR}/inc/functions/clean-magetools.sh";
