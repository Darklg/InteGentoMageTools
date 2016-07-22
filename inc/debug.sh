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
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='1' WHERE path IN('dev/debug/template_hints','dev/debug/template_hints_blocks');";

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
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='0' WHERE path IN('dev/debug/template_hints','dev/debug/template_hints_blocks');";

###################################
## Empty cache
###################################

echo "-- Emptying cache";
. "${SOURCEDIR}/inc/empty-cache.sh" &> /dev/null
