#!/bin/bash

###################################
## Ask infos
###################################

# Project ID
read -p "Project ID : " project_id;
if [[ $project_id == '' ]]; then
    project_id="project-${random_project_id}";
fi;
echo "- Project ID is : '${project_id}'.";

# Get MySQL values
read -p "MySQL user : " mysql_user;
if [[ $mysql_user == '' ]]; then
    mysql_user='root';
fi;
echo "- MySQL user is : '${mysql_user}'.";

read -p "MySQL pass : " mysql_pass;
if [[ $mysql_pass == '' ]]; then
    mysql_pass='root';
fi;
echo "- MySQL pass is : '${mysql_pass}'.";

echo "- Add default local.xml";
cp "${SOURCEDIR}files/local.xml" "app/etc/local.xml";

# Set values
echo "- Set values in local.xml";
sed -i '' "s/INTEGENTODBNAME/${project_id}/" "app/etc/local.xml";
sed -i '' "s/INTEGENTOUSERNAME/${mysql_user}/" "app/etc/local.xml";
sed -i '' "s/INTEGENTOPASSWORD/${mysql_pass}/" "app/etc/local.xml";

# Cache config
. "${SOURCEDIR}/inc/functions/set-mysql-file.sh";
