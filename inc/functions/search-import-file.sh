#!/bin/bash

###################################
## Search an import file
###################################

database_file_import="";
database_file_exists='0';

for f in $(ls *.sql.gz 2>/dev/null); do
    read -p "Unzip ${f} ? [Y/n]:" unzip_sqlgz_file;
    if [[ $unzip_sqlgz_file != 'n' ]]; then
        gunzip "${f}";
        break 1;
    fi;
done;

for f in $(ls *.sql 2>/dev/null); do
    database_file_import="${f}";
    database_file_exists="1";
    break 1;
done;
