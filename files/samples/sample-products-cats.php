<?php

include dirname(__FILE__) . '/bootstrap.php';
include dirname(__FILE__) . '/provider.php';

$_nbProducts = 10;

/* ----------------------------------------------------------
  Create Object
---------------------------------------------------------- */

$provider = new IntegentoProvider();

/* ----------------------------------------------------------
  Product Creation
---------------------------------------------------------- */

echo "-- Creating sample products\n";
$productIds = array();
for ($i = 1; $i <= $_nbProducts; $i++) {
    $tmp_id = 'TEST_' . str_replace(array(' ', '.'), '', microtime());
    $productIds[] = $provider->createDummyProduct($tmp_id, array('name' => 'Test Product ' . $i));
    echo "- Sample product #" . $i . " with SKU " . $tmp_id . "\n";
}

/* ----------------------------------------------------------
  Category creation
---------------------------------------------------------- */

echo "-- Creating sample categories\n";
$_mainCat = $provider->createDummyCategory('Main Category', 'main-category');
$_subCat1 = $provider->createDummyCategory('Sub Category 1', 'sub-category-1', $_mainCat);
$_subSubCat1 = $provider->createDummyCategory('SubSub Category 1', 'subsub-category-1', $_subCat1);
$_subSubCat2 = $provider->createDummyCategory('SubSub Category 2', 'subsub-category-2', $_subCat1);
$_subCat2 = $provider->createDummyCategory('Sub Category 2', 'sub-category-2', $_mainCat);

$_catList = array(
    $_mainCat,
    $_subCat1,
    $_subSubCat1,
    $_subSubCat2,
    $_subCat2
);

/* ----------------------------------------------------------
  Add products to categories
---------------------------------------------------------- */

echo "-- Add products to categories\n";
foreach ($_catList as $_cat) {
    foreach ($productIds as $_pId) {
        echo "- Add products " . $_pId . " to category " . $_cat . "\n";
        Mage::getSingleton('catalog/category_api')->assignProduct($_cat, $_pId);
    }
}

/* ----------------------------------------------------------
  Success
---------------------------------------------------------- */

echo "- Successfully created " . $_nbProducts . " sample products\n";
