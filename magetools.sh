#!/bin/bash

# Mage Tools v 0.10.1
#
# @author      Darklg <darklg.blog@gmail.com>
# @copyright   Copyright (c) 2016 Darklg
# @license     MIT

SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
EXECDIR="$( cd "${SOURCEDIR}" && pwd )/";

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


