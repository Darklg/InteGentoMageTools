<?php

/* Thanks to @antoinekociuba : https://gist.github.com/antoinekociuba/2408d8a7c52342c3930c */

include dirname(__FILE__) . '/bootstrap.php';

$_couponId = 'SAMPLECOUPON';
$_couponName = 'Sample Coupon';

// Websites
$websites = Mage::app()->getWebsites();
$websitesIds = array();
foreach ($websites as $website) {
    $websitesIds[] = $website->getId();
}

// All customer group ids
$customerGroupIds = Mage::getModel('customer/group')->getCollection()->getAllIds();

// SalesRule Rule model
$rule = Mage::getModel('salesrule/rule');

// Rule data
$rule->setName($_couponName)
    ->setDescription($_couponName)
    ->setCouponType(Mage_SalesRule_Model_Rule::COUPON_TYPE_SPECIFIC)
    ->setCouponCode($_couponId)
    ->setUsesPerCustomer(999)
    ->setUsesPerCoupon(999)
    ->setCustomerGroupIds($customerGroupIds)
    ->setIsActive(1)
    ->setConditionsSerialized('')
    ->setActionsSerialized('')
    ->setStopRulesProcessing(0)
    ->setIsAdvanced(1)
    ->setProductIds('')
    ->setSortOrder(0)
    ->setSimpleAction(Mage_SalesRule_Model_Rule::BY_FIXED_ACTION)
    ->setDiscountAmount(10)
    ->setDiscountQty(1)
    ->setDiscountStep(0)
    ->setSimpleFreeShipping('0')
    ->setApplyToShipping('0')
    ->setIsRss(0)
    ->setWebsiteIds($websitesIds)
    ->setStoreLabels(array($_couponName));

// Save rule
$rule->save();

echo "-- Creating Coupon '" . $_couponId . "' : -10€\$£ on cart total \n";
