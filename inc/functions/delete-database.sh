#!/bin/bash

###################################
## Delete database
###################################

mysql --defaults-extra-file=my-magetools.cnf -e "DROP DATABASE ${project_id};";
echo "-- Database is deleted.";
