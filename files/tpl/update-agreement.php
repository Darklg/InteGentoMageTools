<?php
/**
 * Installer Agreements.
 */

try {

    $_core = Mage::getSingleton('core/resource');
    $_write = $_core->getConnection('core_write');
    $_tableAgreements = $_core->getTableName('checkout_agreement');
    $_tableAgreementStore = $_core->getTableName('checkout_agreement_store');

    $agreements_templates = array(
        array(
            'name' => '[Project] Default CGV',
            'checkbox_text' => 'I accept the general terms of sales',
            'content' => '<h2>lorem</h2><p>lorem ipsum facto</p>',
            'is_active' => 1,
            'is_html' => 1
        )
    );

    foreach ($agreements_templates as $key => $template) {

        // Insert new template in db
        $_write->insert($_tableAgreements, $template);
        $_lastInsertId = $_write->lastInsertId();

        // Save new template id in conf
        $_write->insert($_tableAgreementStore, array(
            'agreement_id' => $_lastInsertId,
            'store_id' => 0
        ));

    }

} catch (Exception $e) {
    Mage::logException($e);
    if (Mage::getIsDeveloperMode()) {
        Mage::throwException($e->getMessage());
    }
}
