#!/bin/bash

echo "-- Sample Products";
samples_args="";
if [ -n "${1}" ]; then
    samples_args="-n=${1}";
fi;
php "${SOURCEDIR}/files/samples/sample-products-cats.php" "${samples_args}";
