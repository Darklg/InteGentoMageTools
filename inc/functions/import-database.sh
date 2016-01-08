#!/bin/bash

###################################
## Import database
###################################

# Import dump.sql file if available
if [[ $database_file_exists != '0' ]]; then
    database_file_size=$(du -h "${database_file_import}" | cut -f 1);
    read -p "Import database file '${database_file_import}' (${database_file_size} ) ? [Y/n]:" import_database;
    if [[ $import_database != 'n' ]]; then
        mysql --verbose -u ${mysql_user} -p${mysql_pass} ${project_id} < ${database_file_import};
        echo "-- Database imported from '${database_file_import}'";
    fi;
fi;
