#!/bin/bash

###################################
## Magento settings
###################################

echo "-- Setting base URL";
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{base_url}}' WHERE path IN('web/unsecure/base_url', 'web/unsecure/base_link_url');";
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{base_url}}skin/' WHERE path = 'web/unsecure/base_skin_url';";
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{base_url}}media/' WHERE path = 'web/unsecure/base_media_url';";
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{base_url}}js/' WHERE path = 'web/unsecure/base_js_url';";

read -p "Set secure base URL ? [y/N]: " mysql__securebaseurl;
if [[ $mysql__securebaseurl == 'y' ]]; then
    echo "-- Setting secure base URL";
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{secure_base_url}}' WHERE path IN('web/secure/base_url','web/secure/base_link_url');";
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{secure_base_url}}skin/' WHERE path = 'web/secure/base_skin_url';";
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{secure_base_url}}media/' WHERE path = 'web/secure/base_media_url';";
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='{{secure_base_url}}js/' WHERE path = 'web/secure/base_js_url';";
fi;

echo "-- Add checkmo payment method";
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value = '1' WHERE path = 'payment/checkmo/active';";

echo "-- Setting watermark adapter to GD";
mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET value='GD2' WHERE path IN('design/watermark_adapter/adapter');";


# - Merge Assets
read -p "Disable JS/CSS merge ? [Y/n]: " mysql__disable_merge;
if [[ $mysql__disable_merge != 'n' ]]; then
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE core_config_data SET VALUE = 0 where path IN('dev/js/merge_files','dev/css/merge_css_files');";
    echo "-- JS/CSS merge is now disabled";
fi;

# - Default admin pass
read -p "Set password value to 'password' for admin user [Y/n]: " mysql__password_pass;
if [[ $mysql__password_pass != 'n' ]]; then
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};UPDATE admin_user SET password=CONCAT(MD5('qXpassword'), ':qX') WHERE username='admin' OR user_id=1;";
    echo "-- Admin ids are now 'admin:password'";
fi;

# - Cache
read -p "Set a cache config optimized for Front-End [Y/n]: " mysql__set_cache_config;
if [[ $mysql__disable_merge != 'n' ]]; then
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${project_id};update core_cache_option set value=0 WHERE code in('block_html','layout','translate');update core_cache_option set value=1 WHERE code IN('config','config_api','config_api2','eav','collections');";
    echo "-- Setting cache config";
fi;
