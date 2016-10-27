#!/bin/bash

echo "-- Sample Products";
{ php "${SOURCEDIR}/files/samples/sample-products.php"; } &> /dev/null

php "${SOURCEDIR}/files/samples/sample-products.php";
