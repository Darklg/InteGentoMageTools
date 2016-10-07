#!/bin/bash

###################################
## Get infos
###################################

echo "-- Get infos";
{ . "${SOURCEDIR}/inc/functions/test-getinfos.sh"; } &> /dev/null

###################################
## Set debug
###################################

echo "-- Setting debug";
magetools_setting_init_or_update "dev/debug/template_hints" 1;
magetools_setting_init_or_update "dev/debug/template_hints_blocks" 1;

###################################
## Empty cache
###################################

echo "-- Emptying cache";
. "${SOURCEDIR}/inc/empty-cache.sh" &> /dev/null

###################################
## Sleep for 15 seconds
###################################

for i in {15..1}
do
   echo "... You have $i second(s) to reload your page.";
   sleep 1;
done

###################################
## Unset debug
###################################

echo "-- Unsetting debug";
magetools_setting_init_or_update "dev/debug/template_hints" 0;
magetools_setting_init_or_update "dev/debug/template_hints_blocks" 0;

###################################
## Empty cache
###################################

echo "-- Emptying cache";
. "${SOURCEDIR}/inc/empty-cache.sh" &> /dev/null
