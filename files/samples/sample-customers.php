<?php

/* Thanks to http://inchoo.net/magento/programming-magento/programmaticaly-adding-new-customers-to-the-magento-store/ */

include dirname(__FILE__) . '/bootstrap.php';

$websiteId = Mage::app()->getWebsite()->getId();
$store = Mage::app()->getStore();

/* ----------------------------------------------------------
  Create a customer
---------------------------------------------------------- */

$customer_email = 'test' . mt_rand(0, 1999) . '@example.com';

echo "-- Creating a Customer : '" . $customer_email . "'\n";

$customer = Mage::getModel("customer/customer");
$customer->setWebsiteId($websiteId)
    ->setStore($store)
    ->setFirstname('John')
    ->setLastname('Doe')
    ->setEmail($customer_email)
    ->setPassword($customer_email);

try {
    $customer->save();
} catch (Exception $e) {
    Zend_Debug::dump($e->getMessage());
}

/* ----------------------------------------------------------
  Add an address
---------------------------------------------------------- */

$address = Mage::getModel("customer/address");
$address->setCustomerId($customer->getId())
    ->setFirstname($customer->getFirstname())
    ->setMiddleName($customer->getMiddlename())
    ->setLastname($customer->getLastname())
    ->setCountryId('FR')
    ->setPostcode('75011')
    ->setCity('Paris')
    ->setTelephone('0101010101')
    ->setFax('0101010101')
    ->setCompany('Test')
    ->setStreet('3 rue du Chat')
    ->setIsDefaultBilling('1')
    ->setIsDefaultShipping('1')
    ->setSaveInAddressBook('1');

try {
    $address->save();
} catch (Exception $e) {
    Zend_Debug::dump($e->getMessage());
}
