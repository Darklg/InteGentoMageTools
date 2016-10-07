#!/bin/bash

function magetools_setting_init_or_update {
    tmpvalue=$(mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};SELECT value FROM core_config_data WHERE path = '${1}'" | tr -d '[\+\-\| ]');
    if [[ $tmpvalue != '' ]]; then
        req="use ${project_id};UPDATE core_config_data SET value = '${2}' WHERE path = '${1}';";
    else
        req="use ${project_id};INSERT INTO core_config_data (scope, scope_id, path, value) VALUES ('default', 0, '${1}', '${2}');";
    fi;
    mysql --defaults-extra-file=my-magetools.cnf -e "${req}";
}
