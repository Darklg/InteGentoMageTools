#!/bin/bash

###################################
## Create database
###################################

mysql --defaults-extra-file=my-magetools.cnf -e "CREATE DATABASE ${project_id} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;";
echo "-- Database is created.";
