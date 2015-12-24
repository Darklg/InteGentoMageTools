#!/bin/bash

# Mage Tools v 0.4
#
# @author      Darklg <darklg.blog@gmail.com>
# @copyright   Copyright (c) 2015 Darklg
# @license     MIT

SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";

###################################
## Routing from initial argument
###################################

case "$1" in
    'install')
        echo "## INSTALL";
        . "${SOURCEDIR}/inc/install.sh";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
    'cache' | *)
        echo "## CACHE";
        . "${SOURCEDIR}/inc/empty-cache.sh";
    ;;
esac


