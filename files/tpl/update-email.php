<?php
/**
 * Installer for Email Templates.
 * Copy HTML templates to the Email Template interface in BO.
 */

try {

    $_emailsDate = date('Y-m-d h:i:s');
    $_projectName = 'Project';

    $email_templates = array(
        /* ----------------------------------------------------------
          Public
        ---------------------------------------------------------- */

        /* Newsletter */
        'newsletter_subscription_confirm_email_template' => array(
            'name' => '[' . $_projectName . '] Confirmation newsletter',
            'path' => 'newsletter_subscr_confirm.html',
            'conf' => 'newsletter/subscription/confirm_email_template'
        ),
        'newsletter_subscription_success_email_template' => array(
            'name' => '[' . $_projectName . '] Abonnement newsletter',
            'path' => 'newsletter_subscr_success.html',
            'conf' => 'newsletter/subscription/success_email_template'
        ),
        'newsletter_subscription_un_email_template' => array(
            'name' => '[' . $_projectName . '] Désabonnement newsletter',
            'path' => 'newsletter_unsub_success.html',
            'conf' => 'newsletter/subscription/un_email_template'
        ),

        /* Customer */
        'customer_create_account_email_template' => array(
            'name' => '[' . $_projectName . '] Nouveau compte',
            'path' => 'account_new.html',
            'conf' => 'customer/create_account/email_template'
        ),
        'customer_password_forgot_email_template' => array(
            'name' => '[' . $_projectName . '] Nouveau mot de passe',
            'path' => 'account_password_reset_confirmation.html',
            'conf' => 'customer/password/forgot_email_template'
        ),

        /* Others */
        'contacts_email_email_template' => array(
            'name' => '[' . $_projectName . '] Contact Form',
            'path' => 'contact_form.html',
            'conf' => 'contacts/email/email_template'
        ),
        'sendfriend_email_template' => array(
            'name' => '[' . $_projectName . '] Envoi à un ami',
            'path' => 'product_share.html',
            'conf' => 'sendfriend/email/template'
        ),

        /* ----------------------------------------------------------
          Sales
        ---------------------------------------------------------- */

        /* Order */
        'sales_email_order_comment_template' => array(
            'name' => '[' . $_projectName . '] Commentaire commande',
            'path' => 'sales/order_update.html',
            'conf' => 'sales_email/order_comment/template'
        ),
        'sales_email_order_template' => array(
            'name' => '[' . $_projectName . '] Nouvelle commande',
            'path' => 'sales/order_new.html',
            'conf' => 'sales_email/order/template'
        ),

        /* Shipment */
        'sales_email_shipment_comment_template' => array(
            'name' => '[' . $_projectName . '] Commentaire livraison',
            'path' => 'sales/shipment_update.html',
            'conf' => 'sales_email/shipment_comment/template'
        ),
        'sales_email_shipment_template' => array(
            'name' => '[' . $_projectName . '] Nouvelle livraison',
            'path' => 'sales/shipment_new.html',
            'conf' => 'sales_email/shipment/template'
        ),

        /* Invoice */
        'sales_email_invoice_comment_template' => array(
            'name' => '[' . $_projectName . '] Commentaire Facture',
            'path' => 'sales/invoice_update.html',
            'conf' => 'sales_email/invoice_comment/template'
        ),
        'sales_email_invoice_template' => array(
            'name' => '[' . $_projectName . '] Nouvelle facture',
            'path' => 'sales/invoice_new.html',
            'conf' => 'sales_email/invoice/template'
        ),

        /* Credit memo */
        'sales_email_creditmemo_comment_template' => array(
            'name' => '[' . $_projectName . '] Commentaire Avoir',
            'path' => 'sales/creditmemo_update.html',
            'conf' => 'sales_email/creditmemo_comment/template'
        ),
        'sales_email_creditmemo_template' => array(
            'name' => '[' . $_projectName . '] Nouvel avoir',
            'path' => 'sales/creditmemo_new.html',
            'conf' => 'sales_email/creditmemo/template'
        )
    );


    /* Get stores
    -------------------------- */
    $stores = Mage::app()->getStores();
    $_stores = array();
    foreach ($stores as $store) {
        $_storeId = $store->getId();
        $_stores[] = array(
            'id' => $_storeId,
            'locale' => Mage::getStoreConfig('general/locale/code', $_storeId)
        );
    }

    $mailModel = Mage::getModel('core/email_template');
    $_core = Mage::getSingleton('core/resource');
    $_write = $_core->getConnection('core_write');
    $_tableTemplates = $_core->getTableName('core_email_template');
    $_tableConfig = $_core->getTableName('core_config_data');


    foreach ($email_templates as $key => $template) {

        foreach ($_stores as $_store) {

            // Load template
            $mailTemplate = $mailModel->loadDefault($key, $_store['locale']);
            $mailTemplate->setDesignConfig(array(
                'area' => 'frontend'
            ));

            // Set mail template
            $_templateCode = $template['name'] . ' - ' . $_store['locale'];
            $_tpl = array(
                'template_code' => $_templateCode,
                'added_at' => $_emailsDate,
                'modified_at' => $_emailsDate,
                'orig_template_code' => $key,
                'template_text' => Mage::app()->getTranslator()->getTemplateFile($template['path'], 'email', $_store['locale']),
                'template_type' => $mailTemplate->getData('template_type'),
                'template_subject' => $mailTemplate->getData('template_subject')
            );

            // Delete old templates with the same name
            $_write->delete($_tableTemplates, array(
                'template_code = ?' => $_templateCode
            ));

            // Insert new template in db
            $_write->insert($_tableTemplates, $_tpl);
            $_lastInsertId = $_write->lastInsertId();

            if (isset($template['conf'])) {
                // Delete old conf for template
                $_write->delete($_tableConfig, array(
                    "path = ?" => $template['conf'],
                    "scope_id = ?" => $_store['id']
                ));

                // Save new template id in conf
                Mage::getConfig()->saveConfig($template['conf'], intval($_lastInsertId), 'stores', $_store['id'])->cleanCache();
            }
        }
    }

} catch (Exception $e) {
    Mage::logException($e);
    if (Mage::getIsDeveloperMode()) {
        Mage::throwException($e->getMessage());
    }
}
