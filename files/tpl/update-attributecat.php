<?php
/**
 * Installer Category Attribute.
 */

try {
    /** @var Mage_Core_Model_Resource_Setup $installer */
    $installer = $this;
    $installer->startSetup();

    /* Custom Attributes */
    $_customAttributes = array(
        /* Yes No */
        'custom_select_yesno' => array(
            'input' => 'select',
            'label' => 'Custom Select',
            'note' => 'Help text under',
            'source' => 'eav/entity_attribute_source_boolean',
            'type' => 'int', // int / text / etc
        ),
        /* Text field */
        'custom_text' => array(
            'input' => 'text',
            'label' => 'Custom Text',
            'note' => 'Help text under',
            'type' => 'text', // int / text / etc
        ),
    );

    /* Edit below at your own risks */

    $_defaultAttribute = array(
        'backend' => '',
        'comparable' => false,
        'filterable' => false,
        'global' => Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_STORE,
        'group' => 'General Information',
        'input' => 'text',
        'is_html_allowed_on_front' => false,
        'label' => 'Custom attribute',
        'note' => '',
        'required' => false,
        'searchable' => false,
        'type' => 'text',
        'user_defined' => true,
        'visible' => true,
        'visible_on_front' => true,
        'wysiwyg_enabled' => false,
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
