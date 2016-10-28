#!/bin/bash

###################################
## Import database
###################################

# Import dump.sql file if available
if [[ $database_file_exists != '0' ]]; then
    for f in $(ls *.sql 2>/dev/null); do
        database_file_import="${f}";
        database_file_size=$(du -h "${database_file_import}" | cut -f 1);
        read -p "Import database file '${database_file_import}' - ${database_file_size} ? [Y/n]: " import_database;
        if [[ $import_database != 'n' ]]; then
            database_verbose_arg="--verbose";
            read -p "Verbose mode ? [y/N]: " import_database_verbose;
            if [[ $import_database_verbose != 'y' ]]; then
                database_verbose_arg='';
            fi;

            mysql --defaults-extra-file=my-magetools.cnf ${database_verbose_arg} ${mysql_base} < ${database_file_import};
            echo "-- Database imported from '${database_file_import}'";

            read -p "Delete import file ? [y/N]: " delete_import_file;
            if [[ $delete_import_file == 'y' ]]; then
                rm "${database_file_import}";
                echo "-- Import file deleted";
            fi;

            break 1;
        fi;
    done;
fi;
