#!/bin/bash

###################################
## Create database
###################################

mysql -u ${mysql_user} -p${mysql_pass} -e "CREATE DATABASE ${project_id} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;";
echo "-- Database is created.";
