#!/bin/bash

###################################
## Import database
###################################

# Import dump.sql file if available
if [[ $database_file_exists != '0' ]]; then
    database_file_size=$(du -h "${database_file_import}" | cut -f 1);
    read -p "Import database file '${database_file_import}' (${database_file_size} ) ? [Y/n]:" import_database;
    if [[ $import_database != 'n' ]]; then

        read -p "Verbose mode ? [y/N]:" import_database_verbose;

        database_verbose_arg='';
        if [[ $import_database != 'y' ]]; then
            database_verbose_arg="--verbose";
        fi;

        mysql ${database_verbose_arg} -u ${mysql_user} -p${mysql_pass} ${project_id} < ${database_file_import};
        echo "-- Database imported from '${database_file_import}'";
    fi;
fi;
