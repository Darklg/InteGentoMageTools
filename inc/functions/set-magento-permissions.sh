#!/bin/bash

###################################
## Set permissions
###################################

read -p "Set permissions ? (y/N) " set_permissions;
if [ "${set_permissions}" = "n" ]; then
    find . -type f -exec chmod 644 {} \;
    find . -type d -exec chmod 755 {} \;
    chmod o+w app/etc
    chmod 550 mage;
    mkdir -p var;
    chmod -R 755 var;
    mkdir -p media;
    chmod -R 755 media;
fi;
