<?php

/* ----------------------------------------------------------
  Magento Provider Class
---------------------------------------------------------- */

class IntegentoProvider {
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
     * Original code by Giel Berkers (@kanduvisla)
     * https://gielberkers.com/generating-dummy-products-for-unit-tests-in-magento/
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
            'price' => mt_rand(30, 150),
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
        $special_price = mt_rand(10, 20);
        if ($special_price < 15) {
            $productData['special_price'] = $productData['price'] - $special_price;
        }

        foreach ($additionalData as $key => $value) {
            $productData[$key] = $value;
        }
        $product->setData($productData);
        $product->save();
        return $product->getId();
    }

    public static function setProductLinksFromArray($productId = 0, $products = array()) {
        $_productApi = Mage::getSingleton('catalog/product_link_api');
        if (empty($products)) {
            return false;
        }
        foreach ($products as $crossProductId) {
            if ($crossProductId != $productId) {
                $_productApi->assign('related', $productId, $crossProductId);
                $_productApi->assign('up_sell', $productId, $crossProductId);
                $_productApi->assign('cross_sell', $productId, $crossProductId);
            }
        }
    }

    /**
     * Create a dummy category
     * @param  string  $name     Category name
     * @param  string  $path     Category slug
     * @param  integer $parentId Parent Category
     * @return integer           new Category ID
     */
    public static function createDummyCategory($name = 'your cat name', $path = 'your-cat-url-key', $parentId = 2) {

        $category = Mage::getModel('catalog/category');
        $category->setName($name);
        $category->setUrlKey($path);
        $category->setIsActive(1);
        $category->setDisplayMode('PRODUCTS');
        $category->setIsAnchor(1); //for active anchor
        $category->setStoreId(Mage::app()->getStore()->getId());
        $parentCategory = Mage::getModel('catalog/category')->load($parentId);
        $category->setPath($parentCategory->getPath());
        $category->save();

        return $category->getId();
    }
}
