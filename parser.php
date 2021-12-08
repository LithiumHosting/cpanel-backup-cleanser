#!/usr/bin/env apnscp_php
<?php
require_once('/usr/local/apnscp/vendor/autoload.php');

use Symfony\Component\Yaml\Yaml;

$path = getopt('f:')['f'];
$path = rtrim($path, DIRECTORY_SEPARATOR);
if (! is_dir($path))
{
    die('Invalid Directory: ' . $path);
}

$main_config = $path . DIRECTORY_SEPARATOR . 'userdata/main';

$config = Yaml::parseFile($main_config);

$domains = array_unique(array_merge($config['addon_domains'], $config['sub_domains'], $config['parked_domains']));

foreach ($domains as $domain)
{
    $domain_config = Yaml::parseFile(rtrim($path, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . 'userdata/' . $domain);
    $paths[]       = $path . DIRECTORY_SEPARATOR . 'homedir' . DIRECTORY_SEPARATOR . trim(str_replace($domain_config['homedir'], "", $domain_config['documentroot']), DIRECTORY_SEPARATOR);
}

print implode(' ', $paths);
