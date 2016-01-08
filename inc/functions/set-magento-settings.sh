#!/bin/bash

###################################
## Magento settings
###################################

echo "-- Setting base URL";
mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE core_config_data SET value='{{base_url}}' WHERE path IN('web/unsecure/base_url','web/secure/base_url');";

echo "-- Add checkmo payment method";
mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE core_config_data SET value = '1' WHERE path = 'payment/checkmo/active';";

# - Merge Assets
read -p "Disable JS/CSS merge ? [Y/n]: " mysql__disable_merge;
if [[ $mysql__disable_merge != 'n' ]]; then
    mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE core_config_data SET VALUE = 0 where path IN('dev/js/merge_files','dev/css/merge_css_files');";
    echo "-- JS/CSS merge is now disabled";
fi;

# - Default admin pass
read -p "Set password value to 'password' for admin user [Y/n]: " mysql__password_pass;
if [[ $mysql__password_pass != 'n' ]]; then
    mysql -u ${mysql_user} -p${mysql_pass} -e "use ${project_id};UPDATE admin_user SET password=CONCAT(MD5('qXpassword'), ':qX') WHERE username='admin';";
    echo "-- Admin ids are now 'admin:password";
fi;