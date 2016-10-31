#!/bin/bash

###################################
## Magento settings
###################################

echo "-- Setting base URL";
magetools_setting_init_or_update "web/unsecure/base_url" "{{base_url}}";
magetools_setting_init_or_update "web/unsecure/base_link_url" "{{base_url}}";
magetools_setting_init_or_update "web/unsecure/base_skin_url" "{{base_url}}skin/";
magetools_setting_init_or_update "web/unsecure/base_media_url" "{{base_url}}media/";
magetools_setting_init_or_update "web/unsecure/base_js_url" "{{base_url}}js/";

read -p "Set secure base URL ? [y/N]: " mysql__securebaseurl;
if [[ $mysql__securebaseurl == 'y' ]]; then
    echo "-- Setting secure base URL";
    magetools_setting_init_or_update "web/secure/base_url" "{{secure_base_url}}";
    magetools_setting_init_or_update "web/secure/base_link_url" "{{secure_base_url}}";
    magetools_setting_init_or_update "web/secure/base_skin_url" "{{secure_base_url}}skin/";
    magetools_setting_init_or_update "web/secure/base_media_url" "{{secure_base_url}}media/";
    magetools_setting_init_or_update "web/secure/base_js_url" "{{secure_base_url}}js/";
fi;

echo "-- Add checkmo payment method";
magetools_setting_init_or_update "payment/checkmo/active" 1;

echo "-- Setting watermark adapter to GD";
magetools_setting_init_or_update "design/watermark_adapter/adapter" 'GD2';

# - Merge Assets
read -p "Disable JS/CSS merge ? [Y/n]: " mysql__disable_merge;
if [[ $mysql__disable_merge != 'n' ]]; then
    magetools_setting_init_or_update "dev/js/merge_files" '0';
    magetools_setting_init_or_update "dev/css/merge_css_files" '0';
    echo "-- JS/CSS merge is now disabled";
fi;

# - Default admin pass
read -p "Set password value to 'password' for admin user [Y/n]: " mysql__password_pass;
if [[ $mysql__password_pass != 'n' ]]; then
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};UPDATE admin_user SET username='admin', password=CONCAT(MD5('qXpassword'), ':qX') WHERE username='admin' OR user_id=1;";
    echo "-- Admin ids are now 'admin:password'";
fi;

# - Cache
read -p "Set a cache config optimized for Front-End [Y/n]: " mysql__set_cache_config;
if [[ $mysql__disable_merge != 'n' ]]; then
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};update core_cache_option set value=0 WHERE code in('block_html','layout','translate');update core_cache_option set value=1 WHERE code IN('config','config_api','config_api2','eav','collections');";
    echo "-- Setting cache config";
fi;
