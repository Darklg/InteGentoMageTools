#!/bin/bash

###################################
## Delete database
###################################

mysql -u ${mysql_user} -p${mysql_pass} -e "DROP DATABASE ${project_id};";
echo "-- Database is deleted.";
