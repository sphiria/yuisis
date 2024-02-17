<?php
error_reporting(-1);
ini_set('display_errors', 1);
$wgShowExceptionDetails = true;
if (!defined('MEDIAWIKI')) {
	exit;
}

# names
$wgSitename = getenv('MEDIAWIKI_NAME');
$wgMetaNamespace = getenv('MEDIAWIKI_META_NAMESPACE');
$wgServer = getenv('MEDIAWIKI_SERVER');

# max upload size
$wgMaxUploadSize = 10485760;

# time 
$wgLocaltimezone = "UTC";

# url
$wgScriptPath = "";
$wgScriptExtension = "$wgScriptPath/index.php";
$wgRedirectScript = "$wgScriptPath/redirect.php";
$wgUsePathInfo = true;
$actions = array(
	'edit', 'vedit', 'watch', 'unwatch', 'delete', 'revert', 'rollback',
	'protect', 'unprotect', 'markpatrolled', 'render', 'submit', 'history', 'purge', 'info'
);
foreach ($actions as $action) {
	$wgActionPaths[$action] = "/$1/$action";
}
$wgActionPaths['view'] = "/$1";
$wgArticlePath = $wgActionPaths['view'];
$wgResourceBasePath = $wgScriptPath;
$wgUrlProtocols = array('http://', 'https://', '//');
$wgMainPageIsDomainRoot = true;
#$wgForceHTTPS = true;

# logo
$wgLogo = $wgScriptPath . getenv('MEDIAWIKI_LOGO');
$wgFavicon = $wgScriptPath . getenv('MEDIAWIKI_FAVICON');

# email - TODO: move to env
$wgEnableEmail = false;

# determines how section IDs should be encoded. 
$wgFragmentMode = ['html5'];

# maximum amount of virtual memory available to shell processes, disabled
$wgMaxShellMemory = 0;

# cookies
$wgCookieSameSite = 'Strict';
$wgCookieSecure = true;

# referrer
$wgReferrerPolicy = array('strict-origin-when-cross-origin', 'strict-origin');

# database
$wgDBname = getenv('MEDIAWIKI_DB_NAME');
$wgDBservers = [
	[
		'host' => getenv('MEDIAWIKI_DB_SERVER'),
		'dbname' => getenv('MEDIAWIKI_DB_NAME'),
		'user' => getenv('MEDIAWIKI_DB_USER'),
		'password' => getenv('MEDIAWIKI_DB_PASSWORD'),
		'type' => 'mysql',
		'flags' => DBO_DEFAULT,
		'load' => 0
	]
];
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
	'servers' => array(getenv('REDIS_SERVER')),
);

$wgJobTypeConf['default'] = [
	'class' => 'JobQueueRedis',
	'order' => 'fifo',
	'redisServer' => getenv('REDIS_SERVER'),
	'checkDelay' => true,
	'daemonized' => true
];

$wgJobQueueAggregator = [
	'class' => 'JobQueueAggregatorRedis',
	'redisServer' => getenv('REDIS_SERVER'),
];

# disable unnecessary db hits
$wgMiserMode = true;

# add canonical meta tag on every page
$wgEnableCanonicalServerLink = true;

# allow logged-in users to set a preference whether or not matches in search results should force redirection to that page
$wgSearchMatchRedirectPreference = true;

# images
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";
$wgNativeImageLazyLoading = true;
$wgMaxImageArea = 6.4e7; # fix big boi images
$wgUseInstantCommons = false;
$wgFileExtensions = [ 'png', 'gif', 'jpg', 'jpeg', 'webp', 'ico', ];
$wgApiFrameOptions = 'SAMEORIGIN';

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

# css
$wgAllowSiteCSSOnRestrictedPages = true;

# diff for conflict resolution
$wgDiff = "/usr/bin/diff3";
$wgDiff3 = "/usr/bin/diff3";

# skins
$wgDefaultSkin = "Citizen";
wfLoadSkin('Citizen');
$wgCitizenEnableCJKFonts = true;

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

# google analytics
$wgHooks['BeforePageDisplay'][] = function (OutputPage &$out, Skin &$skin) {
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
	$out->addHeadItem('google-analytics', $code);
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

# footer
$wgFooterIcons = [
	"poweredby" => [
		"mediawiki" => [
			"src" => "https://cdn.gbf.wiki/badge-mediawiki.svg",
			"url" => "https://www.mediawiki.org",
			"alt" => "Powered by MediaWiki",
			"height" => "42",
			"width" => "127",
		],
		"gisla" => [
			"src" => "https://cdn.gbf.wiki/badge-gisla.svg",
			"url" => "https://github.com/sphiria",
			"alt" => "Powered by Gisla",
			"height" => "42",
			"width" => "127",
		]
	],
	"copyright" => [
		"copyright" => [
			"src" => "https://cdn.gbf.wiki/CCBYSA4.svg",
			"url" => $wgRightsUrl,
			"alt" => $wgRightsText,
			"height" => "50",
			"width" => "110",
		]
	]
];