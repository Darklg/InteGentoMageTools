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

echo "-- Disable Google Analytics";
magetools_setting_init_or_update "google/analytics/active" 0;

echo "-- Delete Cookie Domain";
mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};DELETE FROM core_config_data WHERE 'path' = 'web/cookie/cookie_domain';";

# - Clear AheadWorks Helpdesk tables
if [ $(mysql --defaults-extra-file=my-magetools.cnf -N -s -e \
    "select count(*) from information_schema.tables where table_schema='${mysql_base}' and table_name='aw_hdu_mailbox';") -eq 1 ]; then
    read -p "Clear AheadWorks Helpdesk tables ? [y/N]: " mysql_clear_awhdu;
    if [[ $mysql_clear_awhdu == 'y' ]]; then
        mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};\
        SET FOREIGN_KEY_CHECKS = 0;\
        TRUNCATE TABLE aw_hdu_mailbox;\
        TRUNCATE TABLE aw_hdu_message;\
        TRUNCATE TABLE aw_hdu_proto;\
        TRUNCATE TABLE aw_hdu_ticket;\
        TRUNCATE TABLE aw_hdu_ticket_flat;\
        SET FOREIGN_KEY_CHECKS = 1;";
        echo "-- AheadWorks Helpdesk tables are now cleared";
    fi;
fi;

# - Clear orders
if [ $(mysql --defaults-extra-file=my-magetools.cnf -N -s -e \
    "select count(*) from information_schema.tables where table_schema='${mysql_base}' and table_name='sales_flat_order';") -eq 1 ]; then
    read -p "Clear orders ? [y/N]: " mysql_clear_orders;
    if [[ $mysql_clear_orders == 'y' ]]; then
        mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};
        SET FOREIGN_KEY_CHECKS = 0;\
        TRUNCATE TABLE sales_flat_creditmemo;\
        TRUNCATE TABLE sales_flat_creditmemo_comment;\
        TRUNCATE TABLE sales_flat_creditmemo_grid;\
        TRUNCATE TABLE sales_flat_creditmemo_item;\
        TRUNCATE TABLE sales_flat_invoice;\
        TRUNCATE TABLE sales_flat_invoice_comment;\
        TRUNCATE TABLE sales_flat_invoice_grid;\
        TRUNCATE TABLE sales_flat_invoice_item;\
        TRUNCATE TABLE sales_flat_order;\
        TRUNCATE TABLE sales_flat_order_address;\
        TRUNCATE TABLE sales_flat_order_grid;\
        TRUNCATE TABLE sales_flat_order_item;\
        TRUNCATE TABLE sales_flat_order_payment;\
        TRUNCATE TABLE sales_flat_order_status_history;\
        TRUNCATE TABLE sales_flat_quote;\
        TRUNCATE TABLE sales_flat_quote_address;\
        TRUNCATE TABLE sales_flat_quote_address_item;\
        TRUNCATE TABLE sales_flat_quote_item;\
        TRUNCATE TABLE sales_flat_quote_item_option;\
        TRUNCATE TABLE sales_flat_quote_payment;\
        TRUNCATE TABLE sales_flat_quote_shipping_rate;\
        TRUNCATE TABLE sales_flat_shipment;\
        TRUNCATE TABLE sales_flat_shipment_comment;\
        TRUNCATE TABLE sales_flat_shipment_grid;\
        TRUNCATE TABLE sales_flat_shipment_item;\
        TRUNCATE TABLE sales_flat_shipment_track;\
        SET FOREIGN_KEY_CHECKS = 1;";
        echo "-- Orders are now cleared";
    fi;
fi;

# - Clear customers
if [ $(mysql --defaults-extra-file=my-magetools.cnf -N -s -e \
    "select count(*) from information_schema.tables where table_schema='${mysql_base}' and table_name='sales_flat_order';") -eq 1 ]; then
    read -p "Clear customers ? [y/N]: " mysql_clear_customers;
    if [[ $mysql_clear_customers == 'y' ]]; then
        mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};
        SET FOREIGN_KEY_CHECKS = 0;\
        TRUNCATE TABLE customer_address_entity;\
        TRUNCATE TABLE customer_address_entity_datetime;\
        TRUNCATE TABLE customer_address_entity_decimal;\
        TRUNCATE TABLE customer_address_entity_int;\
        TRUNCATE TABLE customer_address_entity_text;\
        TRUNCATE TABLE customer_address_entity_varchar;\
        TRUNCATE TABLE customer_eav_attribute;\
        TRUNCATE TABLE customer_eav_attribute_website;\
        TRUNCATE TABLE customer_entity;\
        TRUNCATE TABLE customer_entity_datetime;\
        TRUNCATE TABLE customer_entity_decimal;\
        TRUNCATE TABLE customer_entity_int;\
        TRUNCATE TABLE customer_entity_text;\
        TRUNCATE TABLE customer_entity_varchar;\
        TRUNCATE TABLE customer_form_attribute;\
        SET FOREIGN_KEY_CHECKS = 1;";
        echo "-- Customers are now cleared";
    else
        # - Anonymize user database
        read -p "Anonymize user database ? [y/N]: " mysql__anonymize_db;
        if [[ $mysql__anonymize_db == 'y' ]]; then
            mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};UPDATE sales_flat_order SET customer_email = CONCAT('fake___', customer_email) WHERE customer_email NOT LIKE 'fake___%';";
            mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};UPDATE customer_entity SET email = CONCAT('fake___', email) WHERE email NOT LIKE 'fake___%';";
            echo "-- Database is now anonymized";
        fi;
    fi;
fi;

# - Anonymize admin emails
read -p "Anonymize admin emails ? [Y/n]: " mysql__anonymize_admin_mails;
if [[ $mysql__anonymize_admin_mails != 'n' ]]; then
    magetools_setting_init_or_update "trans_email/ident_general/email" 'owner@example.com';
    magetools_setting_init_or_update "trans_email/ident_sales/email" 'sales@example.com';
    magetools_setting_init_or_update "trans_email/ident_support/email" 'support@example.com';
    magetools_setting_init_or_update "trans_email/ident_custom1/email" 'custom1@example.com';
    magetools_setting_init_or_update "trans_email/ident_custom2/email" 'custom2@example.com';
    magetools_setting_init_or_update "sales_email/order/copy_to" 'sales+copy@example.com';
    magetools_setting_init_or_update "awrma/contacts/depemail" 'support+awrma@example.com';
    echo "-- Admin email are now anonymized";
fi;

# - Merge Assets
read -p "Disable JS/CSS merge ? [Y/n]: " mysql__disable_merge;
if [[ $mysql__disable_merge != 'n' ]]; then
    magetools_setting_init_or_update "dev/js/merge_files" '0';
    magetools_setting_init_or_update "dev/css/merge_css_files" '0';
    echo "-- JS/CSS merge is now disabled";
fi;

# - Default admin URL
magetools_setting_delete "admin/url/custom";
magetools_setting_delete "admin/url/custom_path";
magetools_setting_delete "admin/url/use_custom";
magetools_setting_delete "admin/url/use_custom_path";

# - Default admin pass
read -p "Set password value to 'password' for all admin users [Y/n]: " mysql__password_pass;
if [[ $mysql__password_pass != 'n' ]]; then
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};UPDATE admin_user SET password=CONCAT(MD5('qXpassword'), ':qX')";
    adminid=$(echo "use ${mysql_base};SELECT username FROM admin_user LIMIT 0,1" | mysql --defaults-extra-file=my-magetools.cnf)
    adminid=$(echo $adminid | cut -d " " -f 2);
    echo -e "-- Admin ids are now ${CLR_GREEN}'${adminid}:password'${CLR_DEF}";
fi;

# - Cache
read -p "Set a cache config optimized for Front-End [Y/n]: " mysql__set_cache_config;
if [[ $mysql__set_cache_config != 'n' ]]; then
    mysql --defaults-extra-file=my-magetools.cnf -e "use ${mysql_base};update core_cache_option set value=0;update core_cache_option set value=1 WHERE code IN('config','config_api','config_api2','eav','translate','collections');";
    echo "-- Setting cache config";
fi;
