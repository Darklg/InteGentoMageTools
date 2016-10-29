#!/bin/bash

###################################
## Cache
###################################

if [[ -d "shell/" ]]; then
    cp "${SOURCEDIR}/files/magetools_flush_cache.php" "shell/magetools_flush_cache.php";
    php -f "shell/magetools_flush_cache.php" >> /dev/null;
    rm -f "shell/magetools_flush_cache.php";
    echo -e "${CLR_GREEN}- Clearing cache.${CLR_DEF}";
fi;

if [[ -d "var/" ]]; then
    rm -rf "var/cache/";
    rm -rf "var/full_page_cache/";
    echo -e "${CLR_GREEN}- Cache folders have been deleted.${CLR_DEF}";
fi;
