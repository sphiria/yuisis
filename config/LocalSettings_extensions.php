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

# TemplateSandbox - 3rd party extension
wfLoadExtension('TemplateSandbox');

# VipsScaler - 3rd party extension
wfLoadExtension('VipsScaler');

# WikiSEO - 3rd party extension
wfLoadExtension('WikiSEO');

# ShortDescription
wfLoadExtension( 'ShortDescription' );

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
$wgVirtualRestConfig['modules']['parsoid'] = array(
    'url' => 'http://localhost:8080/rest.php',
);
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
# wfLoadExtension('MultiPurge');

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
    'tutorial' => array(
        'skip' => true
    ),
    'maxUploads' => 15,
    'licenses' => array(
        # Cygames
        'cygameslicense' => array(
            'msg' => 'mwe-upwiz-license-cygames',
            'templates' => array('cygameslicense')
        ),
        # CC-BY-NC-SA-2.0 required by Flickr
        # Note that this need to be added to mw.FlickrChecker.js every time it is updated
        'cc-by-nc-sa-2.0' => array(
            'msg' => 'mwe-upwiz-license-cc-by-nc-sa-2.0',
            'templates' => array('cc-by-nc-sa-2.0'),
            #'icons' => array('cc-by','cc-nc','cc-sa'), NC icon is missing
            'url' => '//creativecommons.org/licenses/by-nc-sa/2.0/',
            'languageCodePrefix' => 'deed.'
        ),
        # CC-BY-NC-2.0 required by Flickr
        # Note that this need to be added to mw.FlickrChecker.js every time it is updated
        'cc-by-nc-2.0' => array(
            'msg' => 'mwe-upwiz-license-cc-by-nc-2.0',
            'templates' => array('cc-by-nc-2.0'),
            #'icons' => array('cc-by','cc-nc'), NC icon is missing
            'url' => '//creativecommons.org/licenses/by-nc/2.0/',
            'languageCodePrefix' => 'deed.'
        ),
    ),
    # License selection page
    'licensing' => array(
        'thirdParty' => array(
            'type' => 'or',
            'defaults' => 'cygameslicense',
            'licenseGroups' => array(
                array(
                    'head' => 'mwe-upwiz-license-cygames',
                    'licenses' => array(
                        'cygameslicense'
                    )
                ),
                array(
                    # This should be a list of all CC licenses we can reasonably expect to find around the web
                    'head' => 'mwe-upwiz-license-cc-head',
                    'subhead' => 'mwe-upwiz-license-cc-subhead',
                    'licenses' => array(
                        'cc-by-sa-4.0',
                        'cc-by-sa-3.0',
                        'cc-by-sa-2.5',
                        'cc-by-4.0',
                        'cc-by-3.0',
                        'cc-by-2.5',
                        'cc-zero'
                    )
                ),
                array(
                    # Flickr still uses CC 2.0
                    'head' => 'mwe-upwiz-license-flickr-head',
                    'subhead' => 'mwe-upwiz-license-flickr-subhead',
                    'licenses' => array(
                        'cc-by-nc-sa-2.0',
                        'cc-by-nc-2.0',
                        'cc-by-sa-2.0',
                        'cc-by-2.0'
                    )
                ),
                array(
                    'head' => 'mwe-upwiz-license-custom-head',
                    'special' => 'custom',
                    'licenses' => array('custom'),
                ),
                array(
                    'head' => 'mwe-upwiz-license-none-head',
                    'licenses' => array('none')
                ),
            )
        )
    )
);
# Tabs - 3rd party extension
#wfLoadExtension('Tabs');

# Arrays - 3rd party extension
#wfLoadExtension('Arrays');

# ImportArticles - 3rd party extension
#wfLoadExtension('ImportArticles');

# Variables - 3rd party extension
#wfLoadExtension('Variables');

# VariablesLua - 3rd party extension
# wfLoadExtension('VariablesLua');

# Loops - 3rd party extension
#wfLoadExtension('Loops');
#$egLoopsCountLimit = 500;

# DynamicPageList - 3rd party extension
# wfLoadExtension("DynamicPageList3");
# $wgDplSettings['maxResultCount'] = 1000;

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

# EmbedVideo
# TODO: wfLoadExtension("EmbedVideo");

# discord notifications
#wfLoadExtension('Discord');
#require_once "/secrets/discord.php";
#$wgDiscordDisabledHooks = ["ArticleDeleteComplete", "ArticleUndelete", "ArticleRevisionVisibilitySet", "ArticleProtectComplete", "BlockIpComplete", "UnblockUserComplete", "UserGroupsChanged", "FileDeleteComplete", "FileUndeleteComplete", "AfterImportPage", "ArticleMergeComplete"];