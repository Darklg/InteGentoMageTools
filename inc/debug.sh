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

if magetools_command_exists osascript ; then
    echo "-- Reloading current url in chrome";
    osascript "${SOURCEDIR}/inc/functions/chrome-reload-url.applescript";
else
    debugtimer=15;
    if [ -n "${2}" ]; then
        debugtimer="${2}";
    fi;
    while [ "$debugtimer" -gt 0 ]; do
        echo "... You have $debugtimer second(s) to reload your page.";
        debugtimer=$(($debugtimer - 1));
        sleep 1;
    done;
fi

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
