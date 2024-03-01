<?php
if (!defined('MEDIAWIKI')) {
    exit;
}

wfLoadExtension('Cite');
wfLoadExtension('Gadgets');
wfLoadExtension('InputBox');
wfLoadExtension('Interwiki');
wfLoadExtension('Nuke');
wfLoadExtension('ParserFunctions');
# enable string functions
$wgPFEnableStringFunctions = true;
$wgPFStringLengthLimit = 5000;
wfLoadExtension('Poem');
wfLoadExtension('SpamBlacklist');
wfLoadExtension('MultimediaViewer');
wfLoadExtension('TitleBlacklist');

# CodeEditor
wfLoadExtension('WikiEditor');
wfLoadExtension('CodeEditor');
$wgDefaultUserOptions['usebetatoolbar'] = 1;
wfLoadExtension('SyntaxHighlight_GeSHi');

# Scribunto
wfLoadExtension('Scribunto');
$wgScribuntoDefaultEngine = 'luasandbox';
$wgScribuntoUseCodeEditor = true;
$wgScribuntoUseGeSHi = true;
$wgScribuntoEngineConf['luasandbox']['memoryLimit'] = 50 * 1024 * 1024;
$wgScribuntoEngineConf['luasandbox']['cpuLimit'] = 10;

# captcha
wfLoadExtensions(['ConfirmEdit', 'ConfirmEdit/QuestyCaptcha']);
$wgCaptchaClass = 'QuestyCaptcha';
$arr = array(
    "What's the female main character called? D__e_a" => array('Djeeta', 'DJEETA', 'gita'),
);
foreach ($arr as $key => $value) {
    $wgCaptchaQuestions[] = array('question' => $key, 'answer' => $value);
}
$wgGroupPermissions['bot']['skipcaptcha'] = true; // registered bots
$wgGroupPermissions['sysop']['skipcaptcha'] = true;
$wgGroupPermissions['autoconfirmed']['skipcaptcha'] = true;
$wgGroupPermissions['verified']['skipcaptcha'] = true;
$wgCaptchaTriggers['edit'] = true;
$wgCaptchaTriggers['create'] = true;
$wgCaptchaTriggers['createtalk'] = true;
$wgCaptchaTriggers['addurl'] = true;
$wgCaptchaTriggers['createaccount'] = true;
$wgCaptchaTriggers['badlogin'] = true;
$ceAllowConfirmedEmail = true;

# VisualEditor
wfLoadExtension('VisualEditor');

# TemplateData
wfLoadExtension('TemplateData');

# CodeMirror
wfLoadExtension('CodeMirror');

# TextExtracts
wfLoadExtension('TextExtracts');

# PageImages
wfLoadExtension('PageImages');
$wgPageImagesOpenGraph = false;

# TemplateStyles
wfLoadExtension('TemplateStyles');

# TemplateStylesExtender
wfLoadExtension('TemplateStylesExtender');

# Popups - 3rd party extension
wfLoadExtension('Popups');
$wgPopupsHideOptInOnPreferencesPage = true;
$wgPopupsReferencePreviewsBetaFeature = false;

# TabberNeue
wfLoadExtension('TabberNeue');
$wgTabberNeueEnableAnimation = true;

# AWS - 3rd party extension
if (getenv('AWS_S3_SECRET')) {
    wfLoadExtension('AWS');
    $wgAWSCredentials = [
        'key' => getenv('AWS_S3_KEY'),
        'secret' => getenv('AWS_S3_SECRET')
    ];
    $wgAWSBucketName = "gbf-wiki-cdn";
    $wgAWSRegion = 'us-east-1';
    $wgAWSBucketTopSubdirectory = "/relink";
    $wgFileBackends['s3']['endpoint'] = 'https://16754c1a958bd7ee8342063a2d33ff41.r2.cloudflarestorage.com';
    $wgAWSBucketDomain = "cdn.gbf.wiki";
    $wgFileBackends['s3']['use_path_style_endpoint'] = true;
}

# TemplateSandbox - 3rd party extension
wfLoadExtension('TemplateSandbox');

# VipsScaler - 3rd party extension
wfLoadExtension('VipsScaler');

# WikiSEO - 3rd party extension
wfLoadExtension('WikiSEO');

# ShortDescription
wfLoadExtension('ShortDescription');

# CheckUser - 3rd party extension
wfLoadExtension('CheckUser');
$wgGroupPermissions['sysop']['checkuser'] = true;
$wgGroupPermissions['sysop']['checkuser-log'] = true;
$wgGroupPermissions['sysop']['hideuser'] = true;

# Widgets - 3rd party extension
wfLoadExtension('Widgets');

# CLDR - 3rd party extension
wfLoadExtension('cldr');

# Parsoid
wfLoadExtension('Parsoid', __DIR__ . '/vendor/wikimedia/parsoid/extension.json');
$wgParserEnableLegacyMediaDOM = false;
$wgParsoidSettings = [
    'linting' => true
];

# echo - 3rd party extension
wfLoadExtension('Echo');

# Labeled Section Transclusion - 3rd party extension
wfLoadExtension('LabeledSectionTransclusion');

# cargo
wfLoadExtension('Cargo');
#$wgCargoDBtype = getenv('MEDIAWIKI_CARGO_TYPE');
#$wgCargoDBserver = getenv('MEDIAWIKI_CARGO_SERVER');
#$wgCargoDBname = getenv('MEDIAWIKI_CARGO_NAME');
#$wgCargoDBuser = getenv('MEDIAWIKI_CARGO_USER');
#$wgCargoDBpassword = getenv('MEDIAWIKI_CARGO_PASSWORD');
$wgCargoPageDataColumns[] = 'categories';
$wgCargoPageDataColumns[] = 'creationDate';
$wgCargoPageDataColumns[] = 'modificationDate';
$wgCargoPageDataColumns[] = 'creator';
# $wgCargoPageDataColumns[] = 'fullText';
$wgCargoPageDataColumns[] = 'numRevisions';
$wgCargoPageDataColumns[] = 'isRedirect';
$wgCargoPageDataColumns[] = 'pageNameOrRedirect';
$wgCargoAllowedSQLFunctions[] = 'REPEAT';
$wgCargoAllowedSQLFunctions[] = 'REPLACE';
$wgCargoAllowedSQLFunctions[] = 'REGEX_REPLACE';
$wgCargoAllowedSQLFunctions[] = 'REGEX_SUBSTR';
$wgCargoAllowedSQLFunctions[] = 'TRIM';
$wgCargoAllowedSQLFunctions[] = 'IN';
$wgCargoAllowedSQLFunctions[] = 'GROUP_CONCAT';
$wgCargoAllowedSQLFunctions[] = 'FIND_IN_SET';
$wgCargoAllowedSQLFunctions[] = 'IF';
$wgCargoAllowedSQLFunctions[] = 'IFNULL';
$wgCargoAllowedSQLFunctions[] = 'ANY_VALUE';

/* 
 TODO: extensions to fix:
 AdvancedSearch

*/

# SimpleMathJax - 3rd party extension
wfLoadExtension('SimpleMathJax');

# MultiPurge
wfLoadExtension('MultiPurge');
if (getenv('CLOUDFLARE_API_TOKEN')) {
    $wgMultiPurgeEnabledServices = array('Cloudflare');
    $wgMultiPurgeServiceOrder = array('Cloudflare');
    $wgMultiPurgeCloudFlareZoneId = getenv('CLOUDFLARE_ZONE_ID');
    $wgMultiPurgeCloudflareApiToken = getenv('CLOUDFLARE_API_TOKEN');
}

# Disambiguator
wfLoadExtension('Disambiguator');

# DiscussionTools
wfLoadExtension('DiscussionTools');

# Linter
wfLoadExtension('Linter');

# UploadWizard
wfLoadExtension('UploadWizard');
$wgUploadNavigationUrl = '/Special:UploadWizard';
$wgUploadWizardConfig = array(
    'debug' => false,
    'altUploadForm' => 'Special:Upload',
    'fallbackToAltUploadForm' => false,
    'alternativeUploadToolsPage' => false,
    'enableFormData' => true,
    'enableMultipleFiles' => true,
    'enableMultiFileSelect' => false,
    'enableCategoryCheck' => false,
    'minAuthorLength' => 0,
    'minSourceLength' => 0,
    'minDescriptionLength' => 0,
    'minCaptionLength' => 0,
    'minTitleLength' => 1,
    'tutorial' => array(
        'skip' => true
    ),
    'uwLanguages' => [
        'en' => 'English'
        ],
    'maxUploads' => 50,
    'licensing' => [
        'ownWorkDefault' => 'own',
        'ownWork' => [
            'type' => 'or',
            'template' => 'licensing',
            'licenses' => [
                'generic',
            ],
        ],
    ],
);
# Variables - 3rd party extension
wfLoadExtension('Variables');

# VariablesLua - 3rd party extension
wfLoadExtension('VariablesLua');

# Loops - 3rd party extension
wfLoadExtension('Loops');
$egLoopsCountLimit = 500;

# ElasticSearch
#wfLoadExtension('Elastica');
#require_once "$IP/extensions/CirrusSearch/CirrusSearch.php";
##$wgDisableSearchUpdate = true;
#$wgCirrusSearchServers = ['localhost'];
#$wgSearchType = 'CirrusSearch';
#$wgCirrusSearchUseCompletionSuggester = 'yes';
#$wgCirrusSearchUseExperimentalHighlighter = true;
##$wgCirrusSearchOptimizeIndexForExperimentalHighlighter = true;
#$wgCirrusSearchAllowLeadingWildcard = false;
#$wgCirrusSearchUseIcuFolding = true;
#$wgCirrusSearchWikimediaExtraPlugin['id_hash_mod_filter'] = true;
#$wgCirrusSearchWikimediaExtraPlugin['super_detect_noop'] = true;