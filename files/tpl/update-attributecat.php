<?php
/**
 * Installer Category Attribute.
 */

try {
    /** @var Mage_Core_Model_Resource_Setup $installer */
    $installer->startSetup();

    /* Custom Attributes */
    $_customAttributes = array(
        'custom_attribute' => array(
            'label' => 'Custom Select',
            'input' => 'select',
            'note' => 'Help text',
            'type' => 'int', // int / text / etc
            'option' => array(
                'values' => array(
                    0 => 'White',
                    1 => 'Black'
                )
            )
        )
    );

    /* Edit below at your own risks */

    $_defaultAttribute = array(
        'backend' => '',
        'comparable' => false,
        'filterable' => false,
        'group' => 'General Information',
        'input' => 'text',
        'is_html_allowed_on_front' => false,
        'label' => 'Custom attribute',
        'required' => false,
        'searchable' => false,
        'type' => 'text',
        'user_defined' => true,
        'visible' => true,
        'visible_on_front' => true,
        'wysiwyg_enabled' => false,
        'global' => Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_STORE
    );

    foreach ($_customAttributes as $_id => $_attr) {
        $installer->addAttribute(Mage_Catalog_Model_Category::ENTITY, $_id, array_merge($_defaultAttribute, $_attr));
    }

    $installer->endSetup();

} catch (Exception $e) {
    Mage::logException($e);
    if (Mage::getIsDeveloperMode()) {
        Mage::throwException($e->getMessage());
    }
}
