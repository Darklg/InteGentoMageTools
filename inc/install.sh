#!/bin/bash

read -p "Project ID : " project_id;

###################################
## Default files
###################################

if [ ! -f index.php ]; then
    echo "- Add default index.php";
    cp "${SOURCEDIR}files/index.php" "index.php";
fi;

if [ ! -f .htaccess ]; then
    echo "- Add default .htaccess";
    cp "${SOURCEDIR}files/default.htaccess" ".htaccess";
fi;

if [ ! -f app/etc/config.xml ]; then
    echo "- Add default config.xml";
    cp "${SOURCEDIR}files/config.xml" "app/etc/config.xml";
fi;

###################################
## Add config files
###################################

if [ ! -f app/etc/local.xml ]; then
    echo "- Add default local.xml";
    cp "${SOURCEDIR}files/local.xml" "app/etc/local.xml";

    # Get MySQL values
    read -p "MySQL user : " mysql_user;
    if [[ $mysql_user == '' ]]; then
        mysql_user='root';
    fi;
    read -p "MySQL pass : " mysql_pass;
    if [[ $mysql_pass == '' ]]; then
        mysql_pass='root';
    fi;

    # Set values
    echo "- Set values in local.xml";
    sed -i '' "s/INTEGENTODBNAME/${project_id}/" "app/etc/local.xml";
    sed -i '' "s/INTEGENTOUSERNAME/${mysql_user}/" "app/etc/local.xml";
    sed -i '' "s/INTEGENTOPASSWORD/${mysql_pass}/" "app/etc/local.xml";

else :
    echo "- Extracting values from local.xml";
    datalocal=`cat app/etc/local.xml`;
    mysql_user=$(sed -ne '/username/{s/.*<username><\!\[CDATA\[\(.*\)\]\]><\/username>.*/\1/p;q;}' <<< "$datalocal");
    mysql_pass=$(sed -ne '/password/{s/.*<password><\!\[CDATA\[\(.*\)\]\]><\/password>.*/\1/p;q;}' <<< "$datalocal");
fi;

###################################
## DB
###################################

# Create database
create_database='n';
if ! mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id}"; then
    echo "- Database ${project_id} does not exist";

    read -p "Create database ? [Y/n]:" create_database;
    if [[ $create_database != 'n' ]]; then
        mysql -u ${mysql_user} -p${mysql_pass} -e "CREATE DATABASE ${project_id} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;";
        echo "-- Database is created";
    fi;
fi;

# Import database if database creation
if [[ $create_database != 'n' ]]; then
    # Search an import file
    database_file_import="";
    database_file_exists='0';
    for f in $(ls *.sql 2>/dev/null); do
        database_file_import="${f}";
        database_file_exists="1";
        break 1;
    done

    # Import dump.sql file if available
    if [[ $database_file_exists != '0' ]]; then
        read -p "Import database file '${database_file_import}' ? [Y/n]:" import_database;
        if [[ $import_database != 'n' ]]; then
            echo "-- Database imported from '${database_file_import}'";
            mysql -u ${mysql_user} -p${mysql_pass} ${project_id} < ${database_file_import};
        fi;
    fi;
fi;

if ! mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id}"; then
    echo "- Database ${project_id} still does not exist";
else
    echo "- Database ${project_id} does exist";

    # Magento settings
    echo "-- Setting base URL";
    mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE core_config_data SET value='{{base_url}}' WHERE path IN('web/unsecure/base_url','web/secure/base_url');";
    echo "-- Add checkmo payment method";
    mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE core_config_data SET value = '1' WHERE path = 'payment/checkmo/active';";
    read -p "Set password value to 'password' for admin user [Y/n]: " mysql__password_pass;
    if [[ $mysql__password_pass != 'n' ]]; then
        echo "-- Admin ids are now 'admin:password";
        mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE admin_user SET password=CONCAT(MD5('qXpassword'), ':qX') WHERE username='admin';";
    fi;
    read -p "Disable JS/CSS merge ? [Y/n]: " mysql__disable_merge;
    if [[ $mysql__disable_merge != 'n' ]]; then
        echo "-- JS/CSS merge is now disabled";
        mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE core_config_data SET VALUE = 0 where path IN('dev/js/merge_files','dev/css/merge_css_files');";
    fi;
fi

# read -p "Project tmp domain (without http) : " project_domain;

###################################
## Set permissions
###################################

read -p "Set permissions ? (y/N) " set_permissions;
if [ "${set_permissions}" = "n" ]; then
    find . -type f -exec chmod 644 {} \;
    find . -type d -exec chmod 755 {} \;
    chmod o+w app/etc
    chmod 550 mage;
    mkdir -p var;
    chmod -R 755 var;
    mkdir -p media;
    chmod -R 755 media;
fi;
