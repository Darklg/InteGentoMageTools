<?php
/**
 * @author Antoine Kociuba <contact@agence-soon.fr>
 */

require_once 'abstract.php';

class Flush_Cache_Shell extends Mage_Shell_Abstract
{
    /**
     * Run script
     */
    public function run()
    {
        try {
            echo "Start flushing cache at " . date("Y-m-d H:i:s") . PHP_EOL;
            Mage::dispatchEvent('adminhtml_cache_flush_all');
            Mage::app()->getCacheInstance()->flush();
            echo "Cache has been successfully flushed." . PHP_EOL;
        } catch (Exception $e) {
            echo $e->getMessage();
        }
    }
    /**
     * Retrieve Usage Help Message
     */
    public function usageHelp()
    {
        return <<<USAGE
Usage:  php flushcache.php
USAGE;
    }
}
$shell = new Flush_Cache_Shell();
$shell->run();
