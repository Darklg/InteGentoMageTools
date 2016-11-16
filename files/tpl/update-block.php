<?php
/**
 * Installer Block CMS.
 */

try {

    /* Block details
    -------------------------- */

    $blockContent = <<<HTML
<div>Block CMS</div>
HTML;

    /* Create blocks
    -------------------------- */

    $cmsBlocksToCreateData = array(
        array(
            'title' => "Block CMS",
            'identifier' => "block_cms",
            'content' => $blockContent,
            'is_active' => true,
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

    /* Install
    -------------------------- */


    /* @var $cmsBlockModel Mage_Cms_Model_Block */
    $cmsBlockModel = Mage::getModel('cms/block');

    $cmsBlocks = array();
    foreach ($cmsBlocksToCreateData as $data) {
        /* Create one block by store */
        if (isset($data['integento_multistore']) && $data['integento_multistore']) {
            unset($data['integento_multistore']);
            foreach ($_stores as $_store) {
                $data['stores'] = array($_store['id']);
                $cmsBlocks[] = $data;
            }
        } else {
            $cmsBlocks[] = $data;
        }
    }

    foreach ($cmsBlocks as $data) {
        $cmsBlock = clone $cmsBlockModel;
        $blockId = false;
        $cmsBlock->load($data['identifier'], 'identifier');
        if (isset($data['stores']) && is_array($data['stores']) && count($data['stores']) == 1) {
            /* Load block by store */
            $collection = Mage::getModel('cms/block')->getCollection();
            $collection->addStoreFilter($data['stores'][0]);
            $collection->addFieldToFilter('identifier', $data['identifier']);
            $cmsBlockTmp = $collection->getFirstItem();
            if ($cmsBlockTmp->getId()) {
                $blockId = $cmsBlockTmp->getId();
            }
        } else {
            $blockId = $cmsBlock->getId();
        }

        // Create CMS block if it doesn't exist
        if (!$blockId) {
            $cmsBlock->setData($data);
        } else {
            $data['block_id'] = $blockId;
            $cmsBlock->addData($data);
        }

        $cmsBlock->save();
    }


} catch (Exception $e) {
    Mage::logException($e);
    if (Mage::getIsDeveloperMode()) {
        Mage::throwException($e->getMessage());
    }
}
