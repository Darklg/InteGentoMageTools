#!/bin/bash

###################################
## Search an import file
###################################

database_file_import="";
database_file_exists='0';

for f in $(ls *.sql 2>/dev/null); do
    database_file_import="${f}";
    database_file_exists="1";
    break 1;
done;
