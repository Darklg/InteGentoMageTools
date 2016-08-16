<?php
/**
 * Installer.
 */

try {
    /* @var $installer Mage_Core_Model_Resource_Setup */
    $installer = $this;

    $cmsPageTitle = 'Page CMS Type';
    $cmsPageId = 'cms-type';
    $cmsPageContent = <<<HTML
<div>Hellow</div>
HTML;

    /* CMS ID
    -------------------------- */

    $cmsPagesToCreateData = array(
        array(
            'title' => $cmsPageTitle,
            'content_heading' => $cmsPageTitle,
            'meta_keywords' => '',
            'meta_description' => '',
            'root_template' => 'one_column',
            'identifier' => $cmsPageId,
            'content' => $cmsPageContent,
            'is_active' => true,
            'stores' => array(Mage_Core_Model_App::ADMIN_STORE_ID),
            'sort_order' => 0
        )
    );

    /* @var $block Mage_Cms_Model_Page */
    $cmsPageModel = Mage::getModel('cms/page');

    foreach ($cmsPagesToCreateData as $data) {
        $cmsPage = clone $cmsPageModel;
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
