<?php
/**
 * Installer CMS Page.
 */

try {
    /* @var $installer Mage_Core_Model_Resource_Setup */
    $installer = $this;

    $cmsPagesToCreateData = array(
        array(
            'title' => 'Page CMS Type',
            'identifier' => 'cms-type',
            'autofill_content' => 1
        )
    );

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
        'is_active' => true,
        'stores' => array(Mage_Core_Model_App::ADMIN_STORE_ID),
        'sort_order' => 0
    );

    /* @var $block Mage_Cms_Model_Page */
    $cmsPageModel = Mage::getModel('cms/page');

    foreach ($cmsPagesToCreateData as $data) {
        $cmsPage = clone $cmsPageModel;
        $data = array_merge($cmsDefault, $data);

        if (isset($data['autofill_content']) && $data['autofill_content']) {
            $data['content_heading'] = $data['title'];
            $data['content'] = '<p>' . $data['title'] . '</p>';
        }

        $cmsPage->load($data['identifier'], 'identifier');

        // Create CMS Page if it doesn't exist
        if (!$cmsPage->getId()) {
            $cmsPage->setData($data);
        } else {
            $cmsPage->addData($data);
        }

        $cmsPage->save();
    }

} catch (Exception $e) {
    Mage::logException($e);
}
