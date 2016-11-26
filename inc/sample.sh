#!/bin/bash

###################################
## Coupons
###################################

if [[ ${1} == 'coupon' ]];then
    echo "-- Sample Coupons";
    php "${SOURCEDIR}/files/samples/sample-coupons.php";
    return;
fi;

###################################
## Customer
###################################

if [[ ${1} == 'customer' ]];then
    echo "-- Sample Customer";
    php "${SOURCEDIR}/files/samples/sample-customers.php";
    return;
fi;

###################################
## Products / Categories
###################################

echo "-- Sample Products";
samples_args="";
if [ -n "${1}" ]; then
    samples_args="-n=${1}";
fi;
php "${SOURCEDIR}/files/samples/sample-products-cats.php" "${samples_args}";
