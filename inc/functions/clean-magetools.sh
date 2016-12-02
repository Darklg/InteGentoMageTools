#!/bin/bash

# Delete Magetools config
if [ -f my-magetools.cnf ]; then
    rm my-magetools.cnf
fi;

# Delete Magetools helpers
unset -f magetools_setting_init_or_update;
unset -f magetools_load_update_template;
unset -f magetools_config_check_xml;
unset -f magetools_command_exists;
unset -f magetools_wait_for;
