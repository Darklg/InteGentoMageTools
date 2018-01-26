#!/bin/bash

###################################
## Ask infos
###################################

# MySQL base
read -p "MySQL base : " mysql_base;
if [[ $mysql_base == '' ]]; then
    mysql_base="project-${random_mysql_base}";
fi;
echo -e "- MySQL base is : ${CLR_GREEN}${mysql_base}${CLR_DEF}.";

# Get MySQL values
read -p "MySQL user : " mysql_user;
if [[ $mysql_user == '' ]]; then
    mysql_user='root';
fi;
echo -e "- MySQL user is : ${CLR_GREEN}${mysql_user}${CLR_DEF}.";

read -p "MySQL pass : " mysql_pass;
if [[ $mysql_pass == '' ]]; then
    mysql_pass='root';
fi;
echo -e "- MySQL pass is : ${CLR_GREEN}${mysql_pass}${CLR_DEF}.";

echo "- Add default local.xml";
cp "${SOURCEDIR}files/local.xml" "app/etc/local.xml";

# Set values
echo "- Set values in local.xml";
magetools_sed "s/INTEGENTODBNAME/${mysql_base}/" "app/etc/local.xml";
magetools_sed "s/INTEGENTOUSERNAME/${mysql_user}/" "app/etc/local.xml";
magetools_sed "s/INTEGENTOPASSWORD/${mysql_pass}/" "app/etc/local.xml";

# Cache config
. "${SOURCEDIR}/inc/functions/set-mysql-file.sh";
