#!/bin/bash

###################################
## Set permissions
###################################

read -p "Set permissions ? (y/N) " set_permissions;
if [[ $set_permissions == 'y' ]]; then
    echo "- Permissions globales";
    # find . -type f -exec chmod 644 {} \;
    # find . -type d -exec chmod 755 {} \;
    chmod o+w app/etc
    chmod 550 mage;
    echo "- Permissions var/";
    mkdir -p var;
    chmod -R 755 var;
    find var/ -type f -exec chmod 600 {} \;
    find var/ -type d -exec chmod 700 {} \;
    echo "- Permissions media/";
    mkdir -p media;
    chmod -R 755 media;
    find media/ -type f -exec chmod 600 {} \;
    find media/ -type d -exec chmod 700 {} \;
    echo "- Permissions includes/";
    chmod 700 includes
    chmod 600 includes/config.php
fi;
