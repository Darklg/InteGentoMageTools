<?php
/**
 * Installer Config value.
 */

try {
    /** @var Mage_Core_Model_Resource_Setup $installer */
    Mage::getModel('core/config')->saveConfig('catalog/frontend/include_jquery', 0);

} catch (Exception $e) {
    Mage::logException($e);
    if (Mage::getIsDeveloperMode()) {
        Mage::throwException($e->getMessage());
    }
}
