<?php
/**
 * Create Sample Products
 *
 * Original code by Giel Berkers (@kanduvisla)
 * https://gielberkers.com/generating-dummy-products-for-unit-tests-in-magento/
 */

include dirname(__FILE__) . '/bootstrap.php';

$_nbProducts = 5;

/* ----------------------------------------------------------
  Product Provider Class
---------------------------------------------------------- */

class ProductProvider {
    /**
     * @var int Default tax class ID to provide for dummy products
     */
    private static $taxClassId;

    /**
     * @var int Attribute set ID to provide for dummy products
     */
    private static $attributeSetId;

    /**
     * @var array website IDs to set for dummy products
     */
    private static $websiteIds;

    /**
     * Create a dummy product
     * @param string $sku The SKU of the product
     * @param array $additionalData An array with (additional) data
     * @return int The Product ID of the newly created product
     */
    public static function createDummyProduct($sku, $additionalData = array()) {
        if (!self::$attributeSetId) {
            self::$attributeSetId = Mage::getModel('catalog/product')->getDefaultAttributeSetId();
        }
        if (!self::$taxClassId) {
            self::$taxClassId = Mage::getModel('tax/class')->getCollection()->getFirstItem()->getId();
        }
        if (!self::$websiteIds) {
            $websites = Mage::app()->getWebsites();
            self::$websiteIds = array();
            foreach ($websites as $website) {
                self::$websiteIds[] = $website->getId();
            }
        }
        $product = Mage::getModel('catalog/product');

        $qty = max(0, mt_rand(10, 150) - 50);
        $productData = array(
            'sku' => $sku,
            'name' => 'Testproduct: ' . $sku,
            'description' => 'Description for ' . $sku,
            'short_description' => 'Short description for ' . $sku,
            'weight' => mt_rand(1, 15),
            'price' => mt_rand(10, 150),
            'attribute_set_id' => self::$attributeSetId,
            'tax_class_id' => self::$taxClassId,
            'stock_data' => array(
                'qty' => $qty,
                'is_in_stock' => $qty > 1,
                'use_config_manage_stock' => 0,
                'manage_stock' => 1
            ),
            'visibility' => Mage_Catalog_Model_Product_Visibility::VISIBILITY_BOTH,
            'status' => Mage_Catalog_Model_Product_Status::STATUS_ENABLED,
            'type_id' => Mage_Catalog_Model_Product_Type::TYPE_SIMPLE,
            'website_ids' => self::$websiteIds
        );
        foreach ($additionalData as $key => $value) {
            $productData[$key] = $value;
        }
        $product->setData($productData);
        $product->save();
        return $product->getId();
    }
}

/* ----------------------------------------------------------
  Create Object
---------------------------------------------------------- */

$provider = new ProductProvider();

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
  Success
---------------------------------------------------------- */

echo "- Successfully created " . $_nbProducts . " sample products\n";
