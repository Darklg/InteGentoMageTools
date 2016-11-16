<?php

include dirname(__FILE__) . '/bootstrap.php';
include dirname(__FILE__) . '/provider.php';

$options = getopt("n::");

$_nbProducts = 10;
if (isset($options['n']) && is_numeric($options['n'])) {
    $_nbProducts = $options['n'];
}

/* ----------------------------------------------------------
  Create Object
---------------------------------------------------------- */

$provider = new IntegentoProvider();

/* ----------------------------------------------------------
  Product Creation
---------------------------------------------------------- */

echo "-- Creating " . $_nbProducts . " sample products\n";
$productIds = array();
try {
    for ($i = 1; $i <= $_nbProducts; $i++) {
        $tmp_id = 'TEST_' . str_replace(array(' ', '.'), '', microtime());
        $productIds[$i] = $provider->createDummyProduct($tmp_id, array('name' => 'Test Product ' . $i));
        echo "- Sample product #" . $i . " with SKU " . $tmp_id . "\n";
    }
} catch (Exception $e) {
    echo "/!\\ Product creation failed\n";
}

/* ----------------------------------------------------------
  Add product links
---------------------------------------------------------- */

echo "-- Creating Product Links\n";
try {
    foreach ($productIds as $i => $_pId) {
        echo "- Setting Product Links on product #" . $i . "\n";
        $provider->setProductLinksFromArray($_pId, $productIds);
    }
} catch (Exception $e) {
    echo "/!\\ Product Product Links failed\n";
}

/* ----------------------------------------------------------
  Category creation
---------------------------------------------------------- */

if (!empty($productIds)) {
    echo "-- Creating sample categories\n";
    $_catList = array();
    try {
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
    } catch (Exception $e) {
        echo "/!\\ Category creation failed\n";
    }
}

/* ----------------------------------------------------------
  Add products to categories
---------------------------------------------------------- */

if (!empty($_catList)) {
    echo "-- Add products to categories\n";
    try {
        foreach ($_catList as $_cat) {
            foreach ($productIds as $_pId) {
                echo "- Add products " . $_pId . " to category " . $_cat . "\n";
                Mage::getSingleton('catalog/category_api')->assignProduct($_cat, $_pId);
            }
        }
    } catch (Exception $e) {
        echo "/!\\ Category association failed\n";
    }
}

/* ----------------------------------------------------------
  Success
---------------------------------------------------------- */

echo "- Successfully created " . $_nbProducts . " sample products\n";
