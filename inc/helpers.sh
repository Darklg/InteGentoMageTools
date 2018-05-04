#!/bin/bash

function magetools_setting_init_or_update {
    tmpvalue=$(mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};SELECT value FROM core_config_data WHERE path = '${1}'" | tr -d '[\+\-\| ]');
    if [[ $tmpvalue != '' ]]; then
        req="use ${mysql_base};UPDATE core_config_data SET value = '${2}' WHERE path = '${1}';";
    else
        req="use ${mysql_base};INSERT INTO core_config_data (scope, scope_id, path, value) VALUES ('default', 0, '${1}', '${2}');";
    fi;
    mysql --defaults-extra-file=my-magetools.cnf -e "${req}";
}

function magetools_setting_delete {
    tmpvalue=$(mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};SELECT value FROM core_config_data WHERE path = '${1}'" | tr -d '[\+\-\| ]');
    if [[ $tmpvalue != '' ]]; then
        req="use ${mysql_base};DELETE FROM core_config_data WHERE path = '${1}';";
    fi;
    mysql --defaults-extra-file=my-magetools.cnf -e "${req}";
}

function magetools_load_update_template {
    rm "${update_file}";
    cp "${SOURCEDIR}/files/tpl/update-${1}.php" "${update_file}";
    echo "- Template file for '${1}' update loaded";
    return;
}

function magetools_config_check_xml {
    if grep -q "<$2>" "$conf_file";
    then
        echo "<$2> is defined.";
    else
        magetools_sed "s/\<\/$1\>/\\<$2\>\<\/$2\><\/$1\>/" $conf_file;
    fi
}

function magetools_command_exists () {
    type "$1" &> /dev/null ;
}


function magetools_wait_for () {
    debugtimer=15;
    if [ -n "${1}" ]; then
        debugtimer="${1}";
    fi;
    while [ "$debugtimer" -gt 0 ]; do
        seconds_name='seconds';
        if [ "$debugtimer" -lt 2 ];then
            seconds_name='second';
        fi;
        echo -ne "You have $debugtimer $seconds_name to reload your page...\r";
        debugtimer=$(($debugtimer - 1));
        sleep 1;
    done;
    echo -ne '\r\n'

}


function magetools_sed(){
    sed -i.bak ${1} ${2};
    rm "${2}.bak";
}
