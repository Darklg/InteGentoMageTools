<?php
/**
 * Installer CMS Page.
 */

try {

    $cmsPagesToCreateData = array(
        array(
            'title' => 'Page CMS Type',
            'identifier' => 'cms-type',
            'autofill_content' => true,
            'integento_multistore' => true
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

    /* CMS ID
    -------------------------- */

    $cmsDefault = array(
        'title' => 'Default page',
        'content_heading' => '',
        'meta_keywords' => '',
        'meta_description' => '',
        'root_template' => 'one_column',
        'identifier' => 'default-id',
        'content' => '',
        'layout_update_xml' => '',
        'is_active' => true,
        'stores' => array(Mage_Core_Model_App::ADMIN_STORE_ID),
        'sort_order' => 0
    );

    $cmsPages = array();
    foreach ($cmsPagesToCreateData as $data) {
        /* Create one page by store */
        if (isset($data['integento_multistore']) && $data['integento_multistore']) {
            unset($data['integento_multistore']);
            foreach ($_stores as $_store) {
                $data['stores'] = array($_store['id']);
                $cmsPages[] = $data;
            }
        } else {
            $cmsPages[] = $data;
        }
    }

    foreach ($cmsPages as $data) {
        $cmsPage = Mage::getModel('cms/page');
        $data = array_merge($cmsDefault, $data);

        if (isset($data['autofill_content']) && $data['autofill_content']) {
            $data['content_heading'] = $data['title'];
            $data['content'] = '<p>' . $data['title'] . '</p>';
        }

        if (isset($data['stores']) && is_array($data['stores']) && count($data['stores']) == 1) {
            $_storeId = $data['stores'][0];
            $cmsPage->setStore($_storeId)->load($data['identifier'], 'identifier');
            $pageId = $cmsPage->checkIdentifier($data['identifier'], $_storeId);
        } else {
            $cmsPage->load($data['identifier'], 'identifier');
            $pageId = $cmsPage->getId();
        }

        if (!$pageId) {
            // Create CMS Page if it doesn't exist
            $cmsPage->addData($data);
        } else {
            // Update CMS Page
            $data['page_id'] = $pageId;
            $cmsPage->setData($data);
        }

        $cmsPage->save();
    }

} catch (Exception $e) {
    Mage::logException($e);
    if (Mage::getIsDeveloperMode()) {
        Mage::throwException($e->getMessage());
    }
}
