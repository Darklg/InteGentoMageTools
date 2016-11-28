<?php

/* Thanks to http://inchoo.net/magento/programming-magento/programmaticaly-adding-new-customers-to-the-magento-store/ */

include dirname(__FILE__) . '/bootstrap.php';

$websiteId = Mage::app()->getWebsite()->getId();
$store = Mage::app()->getStore();

$_randomNames = array(
    'Roosevelt Moore',
    'Anderson Tague',
    'Russell Mcdaniel',
    'Karl Lary',
    'Donovan Beason',
    'Geoffrey Thorsen',
    'Ismael Howser',
    'Zachary Malin',
    'Bruce Desir',
    'Alex Southwood',
    'Irvin Soper',
    'Chad Mullaney',
    'Herschel Silvey',
    'German Fiorillo',
    'Leon Maas',
    'Tristan Rix',
    'Jose Cottingham',
    'Junior Gildea',
    'Christoper Crotts',
    'Courtney Boer'
);

$_customerName = explode(' ', $_randomNames[mt_rand(0, count($_randomNames) - 1)]);
$_customerEmail = 'test-' . strtolower($_customerName[0]) . '-' . mt_rand(0, 1999) . '@example.com';
$_customerStreet = mt_rand(1, 20) . ' rue du Chat';
$_customerZip = '750' . sprintf("%02d", mt_rand(1, 20));
$_customerPrefix = false;
/* Get last customer prefix */
$prefixes = Mage::helper('customer')->getNamePrefixOptions();
if (is_array($prefixes)) {
    end($prefixes);
    $first_key = key($prefixes);
    if (!empty($first_key)) {
        $_customerPrefix = $first_key;
    }
}

/* ----------------------------------------------------------
  Create a customer
---------------------------------------------------------- */

$customer = Mage::getModel("customer/customer");
$customer->setWebsiteId($websiteId)
    ->setStore($store)
    ->setFirstname($_customerName[0])
    ->setLastname($_customerName[1])
    ->setEmail($_customerEmail)
    ->setPassword($_customerEmail);

if ($_customerPrefix) {
    $customer->setPrefix($_customerPrefix);
}

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
    ->setPostcode($_customerZip)
    ->setCity('Paris')
    ->setTelephone('0101010101')
    ->setFax('0101010101')
    ->setCompany('Test')
    ->setStreet($_customerStreet)
    ->setIsDefaultBilling('1')
    ->setIsDefaultShipping('1')
    ->setSaveInAddressBook('1');

if ($_customerPrefix) {
    $address->setPrefix($customer->getPrefix());
}

try {
    $address->save();
} catch (Exception $e) {
    Zend_Debug::dump($e->getMessage());
}

$_customerName = implode(' ', $_customerName);
echo <<<EOT
-- Creating a Customer :
Name: $_customerName
Email: $_customerEmail

EOT;
