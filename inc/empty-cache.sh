#!/bin/bash

###################################
## Cache
###################################


echo "- Clear cache";
cp "${SOURCEDIR}/files/magetools_flush_cache.php" "shell/magetools_flush_cache.php";
php -f "shell/magetools_flush_cache.php";
rm "shell/magetools_flush_cache.php";

echo "- Deleting var/cache";
rm -rf "var/cache/";
rm -rf "var/full_page_cache/";
