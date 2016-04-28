#!/bin/bash

###################################
## Cache
###################################

if [[ -d "shell/" ]]; then
    echo "- Clearing cache.";
    cp "${SOURCEDIR}/files/magetools_flush_cache.php" "shell/magetools_flush_cache.php";
    php -f "shell/magetools_flush_cache.php";
    rm -f "shell/magetools_flush_cache.php";
fi;

if [[ -d "var/" ]]; then
    echo "- Deleting var/cache.";
    rm -rf "var/cache/";
    rm -rf "var/full_page_cache/";
fi;
