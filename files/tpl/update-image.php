<?php
/**
 * Installer Image config.
 */

try {
    /** @var Mage_Core_Model_Resource_Setup $installer */

    $_skinDir = Mage::getSingleton('core/design_package')->getSkinBaseDir() . DS . 'assets' . DS . 'images';

    /* ----------------------------------------------------------
      Favicon
    ---------------------------------------------------------- */

    $_fileName = DS . 'logo.png';
    $_dirParts = array('favicon', 'default');
    $_logoFile = $_skinDir . $_fileName;
    $_baseDir = Mage::getBaseDir('media');
    foreach ($_dirParts as $_part) {
        $_tmpDir = $_baseDir . DS . $_part;
        if (!is_dir($_tmpDir)) {
            @mkdir($_tmpDir);
            @chmod($_tmpDir, 600);
        }
        $_baseDir = $_tmpDir;
    }
    if (file_exists($_logoFile) && copy($_logoFile, $_baseDir . $_fileName)) {
        Mage::getModel('core/config')->saveConfig('design/head/shortcut_icon', 'default' . $_fileName);
    }

    /* ----------------------------------------------------------
      Catalog Image
    ---------------------------------------------------------- */

    $_fileName = DS . 'catalog.png';
    $_dirParts = array('catalog', 'product', 'placeholder', 'default');
    $_logoFile = $_skinDir . $_fileName;
    $_baseDir = Mage::getBaseDir('media') ;
    foreach ($_dirParts as $_part) {
        $_tmpDir = $_baseDir . DS . $_part;
        if (!is_dir($_tmpDir)) {
            @mkdir($_tmpDir);
            @chmod($_tmpDir, 600);
        }
        $_baseDir = $_tmpDir;
    }
    if (file_exists($_logoFile) && copy($_logoFile, $_baseDir . $_fileName)) {
        Mage::getModel('core/config')->saveConfig('catalog/placeholder/thumbnail_placeholder', 'default' . $_fileName);
        Mage::getModel('core/config')->saveConfig('catalog/placeholder/small_image_placeholder', 'default' . $_fileName);
        Mage::getModel('core/config')->saveConfig('catalog/placeholder/image_placeholder', 'default' . $_fileName);
    }


} catch (Exception $e) {
    Mage::logException($e);
    if (Mage::getIsDeveloperMode()) {
        Mage::throwException($e->getMessage());
    }
}
