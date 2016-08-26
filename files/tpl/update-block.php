<?php
/**
 * Installer Block CMS.
 */

try {

    /* @var $installer Mage_Core_Model_Resource_Setup */
    $installer = $this;

    $blockTitle = "Block CMS";
    $blockIdentifier = "block_cms";
    $blockContent = <<<HTML
<div>Block CMS</div>
HTML;

    $cmsBlocksToCreateData = array(
        array(
            'title' => $blockTitle,
            'identifier' => $blockIdentifier,
            'content' => $blockContent,
            'is_active' => true,
            'stores' => array(Mage_Core_Model_App::ADMIN_STORE_ID)
        )
    );

    /* @var $cmsBlockModel Mage_Cms_Model_Block */
    $cmsBlockModel = Mage::getModel('cms/block');

    foreach ($cmsBlocksToCreateData as $data) {
        $cmsBlock = clone $cmsBlockModel;
        $cmsBlock->load($data['identifier'], 'identifier');

        // Create CMS block if it doesn't exist
        if (!$cmsBlock->getId()) {
            $cmsBlock->setData($data);
        } else {
            $cmsBlock->addData($data);
        }

        $cmsBlock->save();
    }

} catch (Exception $e) {
    Mage::logException($e);
}
