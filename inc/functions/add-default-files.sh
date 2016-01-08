#!/bin/bash

###################################
## Default files
###################################

if [ ! -f index.php ]; then
    echo "- Add default index.php";
    cp "${SOURCEDIR}files/index.php" "index.php";
fi;

if [ ! -f .htaccess ]; then
    echo "- Add default .htaccess";
    cp "${SOURCEDIR}files/default.htaccess" ".htaccess";
fi;

if [ ! -f app/etc/config.xml ]; then
    echo "- Add default config.xml";
    cp "${SOURCEDIR}files/config.xml" "app/etc/config.xml";
fi;
