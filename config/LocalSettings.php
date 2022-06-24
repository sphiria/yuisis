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
$wgUsePathInfo = true;

# time 
$wgLocaltimezone = "UTC";

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

# determines how section IDs should be encoded. 
$wgFragmentMode = [ 'html5', 'legacy' ];

# maximum amount of virtual memory available to shell processes, disabled
$wgMaxShellMemory = 0;

# force https
$wgForceHTTPS = true;

# cookies
$wgCookieSameSite = 'Strict';
$wgCookieSecure = true;

# referrer
$wgReferrerPolicy = array('strict-origin-when-cross-origin', 'strict-origin');

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
$wgMainCacheType = 'redis';
$wgMessageCacheType = 'redis';
$wgParserCacheType = 'redis';
$wgSessionCacheType = 'redis';
$wgLanguageConverterCacheType = 'redis';
$wgMemCachedServers = array();
$wgCacheDirectory = "/tmp/cache";
$wgLocalisationCacheConf = [
	'class' => LocalisationCache::class,
	'store' => 'array',
	'storeClass' => false,
	'storeDirectory' => false,
	'storeServer' => [],
	'forceRecache' => false,
	'manualRecache' => false,
];
$wgObjectCaches['redis'] = array(
    'class' => 'RedisBagOStuff',
    'servers' => array( getenv('REDIS_SERVER') ),
);

$wgJobTypeConf['default'] = [
	'class' => 'JobQueueRedis',
	'order' => 'fifo',
	'redisServer' => getenv('REDIS_SERVER'),
	'checkDelay' => true,
	'daemonized' => true
];

$wgJobQueueAggregator = [
	'class'       => 'JobQueueAggregatorRedis',
	'redisServer' => getenv('REDIS_SERVER'),
];

# disable unnecessary db hits
$wgMiserMode = true;

# add canonical meta tag on every page
$wgEnableCanonicalServerLink = true;

# images
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";
$wgLocalFileRepo = [
    'class' => LocalRepo::class,
    'name' => 'local',
    'directory' => getenv('MEDIAWIKI_UPLOAD_PATH'),
    'scriptDirUrl' => $wgScriptPath,
    'url' => "{$wgScriptPath}/images",
    'hashLevels' => $wgHashedUploadDirectory ? 2 : 0,
    'thumbScriptUrl' => $wgThumbnailScriptPath,
    'transformVia404' => true,
    'deletedDir' => $wgDeletedDirectory,
    'deletedHashLevels' => $wgHashedUploadDirectory ? 3 : 0,
	'disableLocalTransform' => false
];
$wgNativeImageLazyLoading  = true;

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

# remove "realnames"
$wgHiddenPrefs[] = 'realname';

# increase article size
$wgMaxArticleSize = 8192;

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

# google analytics
$wgHooks['BeforePageDisplay'][] = function( OutputPage &$out, Skin &$skin ) {
	$code = <<<'START_END_MARKER'
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-97011956-1', 'auto');
ga('send', 'pageview');
</script>	
START_END_MARKER;
	$out->addHeadItem( 'google-analytics', $code );
	return true;
};

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