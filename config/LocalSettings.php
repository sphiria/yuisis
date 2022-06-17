<?php
if (!defined('MEDIAWIKI')) {
	exit;
}

# names
$wgSitename =  getenv('MEDIAWIKI_NAME');
$wgMetaNamespace = getenv('MEDIAWIKI_META_NAMESPACE');

# max upload size
$wgMaxUploadSize = 10485760;

# server url
$wgServer = getenv('MEDIAWIKI_SERVER');
$wgScriptPath = "";
$wgArticlePath = "/$1";
$wgUsePathInfo = true;

# this makes very pretty urls, ie: article/edit
$actions = array(
	'edit', 'watch', 'unwatch', 'delete', 'revert', 'rollback',
	'protect', 'unprotect', 'markpatrolled', 'render', 'submit', 'history', 'purge', 'info'
);

foreach ($actions as $action) {
	$wgActionPaths[$action] = "/$1/$action";
}
$wgActionPaths['view'] = "/$1";
$wgArticlePath = $wgActionPaths['view'];
$wgScriptExtension  = ".php";
$wgResourceBasePath = $wgScriptPath;
$wgUrlProtocols = array('http://', 'https://', '//');

# logo
$wgLogo = $wgScriptPath . getenv('MEDIAWIKI_LOGO');
$wgFavicon = $wgScriptPath . getenv('MEDIAWIKI_FAVICON');

# email - TODO: move to env
$wgEnableEmail = false;

# database
$wgDBtype = getenv('MEDIAWIKI_DB_TYPE');
$wgDBserver = getenv('MEDIAWIKI_DB_SERVER');
$wgDBname = getenv('MEDIAWIKI_DB_NAME');
$wgDBuser = getenv('MEDIAWIKI_DB_USER');
$wgDBpassword = getenv('MEDIAWIKI_DB_PASSWORD');
$wgDBprefix = "";
$wgDBTableOptions = "ENGINE=InnoDB, DEFAULT CHARSET=binary";
$wgSharedTables[] = "actor";

# cache
$wgMainCacheType = CACHE_MEMCACHED;
$wgParserCacheType = CACHE_MEMCACHED;
$wgMessageCacheType = CACHE_MEMCACHED;
$wgMemCachedServers = [getenv('MEMCACHED_SERVER')];
$wgSessionCacheType = CACHE_MEMCACHED;

# performance
$wgMiserMode = true;

# images
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";

# disable instant commons
$wgUseInstantCommons = false;

# disable pingback
$wgPingback = false;

# language code
$wgLanguageCode = "en-gb";

# timezone
$wgLocaltimezone = "UTC";

# secretkey
$wgSecretKey = getenv('MEDIAWIKI_SECRETKEY');
$wgAuthenticationTokenVersion = getenv('MEDIAWIKI_AUTHTOKEN');

# rights
$wgRightsPage = "";
$wgRightsUrl = "https://creativecommons.org/licenses/by-nc-sa/3.0/";
$wgRightsText = "Creative Commons Attribution-NonCommercial-ShareAlike";
$wgRightsIcon = "$wgScriptPath/resources/assets/licenses/cc-by-nc-sa.png";

# diff for conflict resolution
$wgDiff = "/usr/bin/diff3";
$wgDiff3 = "/usr/bin/diff3";

# skins
$wgDefaultSkin = "vector";
wfLoadSkin('Vector');

# disable creating accounts with the api
$wgAPIModules['createaccount'] = 'ApiDisabled';

# remove export page
function removeExportSpecial(&$aSpecialPages)
{
	unset($aSpecialPages['Export']);
	return true;
}
$wgHooks['SpecialPage_initList'][] = 'removeExportSpecial';

# disable job queue
$wgJobRunRate = 0;

# allow user css/js
$wgAllowUserCss = true;
$wgAllowUserJs = true;

# namespaces
define("NS_RAIDS", 3000);
$wgExtraNamespaces[NS_RAIDS] = "Raids";
define("NS_RAIDS_TALK", 3001);
$wgExtraNamespaces[NS_RAIDS_TALK] = "Raids_talk";
define("NS_META", 4000);
$wgExtraNamespaces[NS_META] = "Meta";
define("NS_META_TALK", 4001);
$wgExtraNamespaces[NS_META_TALK] = "Meta_talk";
$wgNamespacesWithSubpages[NS_META] = true;
define("NS_SCENARIO", 5000);
$wgExtraNamespaces[NS_SCENARIO] = "Scenario";
define("NS_SCENARIO_TALK", 5001);
$wgExtraNamespaces[NS_SCENARIO_TALK] = "Scenario_talk";
define("NS_NEWS", 6000);
$wgExtraNamespaces[NS_NEWS] = "News";
define("NS_NEWS_TALK", 6001);
$wgExtraNamespaces[NS_NEWS_TALK] = "News_talk";
define("NS_ENEMIES", 7000);
$wgExtraNamespaces[NS_ENEMIES] = "Enemies";
define("NS_ENEMIES_TALK", 7001);
$wgExtraNamespaces[NS_ENEMIES_TALK] = "Enemies_talk";
define("NS_SKILLS", 8000);
$wgExtraNamespaces[NS_SKILLS] = "Skills";
define("NS_SKILLS_TALK", 8001);
$wgExtraNamespaces[NS_SKILLS_TALK] = "Skills_talk";
define("NS_TROPHIES", 9000);
$wgExtraNamespaces[NS_TROPHIES] = "Trophies";
define("NS_TROPHIES_TALK", 9001);
$wgExtraNamespaces[NS_TROPHIES_TALK] = "Trophies_talk";
define("NS_DATA", 10000);
$wgExtraNamespaces[NS_DATA] = "Data";
define("NS_DATA_TALK", 10001);
$wgExtraNamespaces[NS_DATA_TALK] = "Data_talk";

# extensions
require_once "LocalSettings_extensions.php";

# permissions
# let editors editprotected and editinterface
$wgGroupPermissions['editors']['editprotected'] = true;
$wgGroupPermissions['editors']['editinterface'] = true;
# let sysop delete deletelogentry and deleterevision
$wgGroupPermissions['sysop']['deletelogentry'] = true;
$wgGroupPermissions['sysop']['deleterevision'] = true;
# let anime edit semiprotected
$wgGroupPermissions['anime']['editsemiprotected']    = true;

# disable variables/arrays deprecation message
$wgDeprecationReleaseLimit = '1.0';