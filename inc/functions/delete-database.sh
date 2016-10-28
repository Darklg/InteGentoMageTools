#!/bin/bash

###################################
## Delete database
###################################

mysql --defaults-extra-file=my-magetools.cnf -e "DROP DATABASE ${mysql_base};";
echo "-- Database is deleted.";
