<?php
if (!defined('MEDIAWIKI')) {
    exit;
}

wfLoadExtension('Cite');
wfLoadExtension('Gadgets');
wfLoadExtension('InputBox');
wfLoadExtension('Interwiki');
wfLoadExtension('LocalisationUpdate');
wfLoadExtension('Nuke');
wfLoadExtension('ParserFunctions');
# enable string functions
$wgPFEnableStringFunctions = true;
$wgPFStringLengthLimit = 5000;
wfLoadExtension('Poem');
wfLoadExtension('Renameuser');
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
$wgCaptchaTriggers['edit']          = true;
$wgCaptchaTriggers['create']        = true;
$wgCaptchaTriggers['createtalk']    = true;
$wgCaptchaTriggers['addurl']        = true;
$wgCaptchaTriggers['createaccount'] = true;
$wgCaptchaTriggers['badlogin']      = true;
$ceAllowConfirmedEmail = true;

# VisualEditor
wfLoadExtension('VisualEditor');

# TemplateData
wfLoadExtension('TemplateData');

# CodeMirror
wfLoadExtension('CodeMirror');

# ImportArticles - 3rd party extension
wfLoadExtension('ImportArticles');

# Variables - 3rd party extension
wfLoadExtension('Variables');

# Loops - 3rd party extension
wfLoadExtension('Loops');

# DynamicPageList - 3rd party extension
wfLoadExtension("DynamicPageList3");
$wgDplSettings['maxResultCount'] = 1000;

# Tabber - 3rd party extension - TODO: deprecate it
wfLoadExtension('Tabber');

# Arrays - 3rd party extension
wfLoadExtension('Arrays');

# TemplateSandbox - 3rd party extension
wfLoadExtension('TemplateSandbox');

# WikiSEO - 3rd party extension
wfLoadExtension('WikiSEO');

# CheckUser - 3rd party extension
wfLoadExtension('CheckUser');
$wgGroupPermissions['sysop']['checkuser'] = true;
$wgGroupPermissions['sysop']['checkuser-log'] = true;
$wgGroupPermissions['sysop']['hideuser'] = true;

# Tabs - 3rd party extension
wfLoadExtension('Tabs');

# Widgets - 3rd party extension
wfLoadExtension('Widgets');

# CLDR - 3rd party extension
wfLoadExtension('cldr');

# StructuredDiscussions - 3rd party extension
wfLoadExtension('Flow');
wfLoadExtension( 'Parsoid', __DIR__ . '/vendor/wikimedia/parsoid/extension.json' );
$wgNamespaceContentModels[NS_TALK] = 'flow-board';
$wgNamespaceContentModels[NS_USER_TALK] = 'flow-board';
$wgNamespaceContentModels[NS_RAIDS_TALK] = 'flow-board';
$wgNamespaceContentModels[NS_META_TALK] = 'flow-board';
$wgNamespaceContentModels[NS_SCENARIO_TALK] = 'flow-board';
$wgNamespaceContentModels[NS_NEWS_TALK] = 'flow-board';
$wgNamespaceContentModels[NS_ENEMIES_TALK] = 'flow-board';
$wgNamespaceContentModels[NS_SKILLS_TALK] = 'flow-board';
$wgNamespacesWithSubpages[3001] = true;
$wgNamespacesWithSubpages[4001] = true;
$wgNamespacesWithSubpages[5001] = true;
$wgNamespacesWithSubpages[6001] = true;
$wgNamespacesWithSubpages[7001] = true;
$wgNamespacesWithSubpages[8001] = true;
$wgGroupPermissions['sysop']['flow-create-board'] = true;
$wgFlowContentFormat = 'html';

# echo - 3rd party extension
wfLoadExtension('Echo');

# Labeled Section Transclusion - 3rd party extension
wfLoadExtension('LabeledSectionTransclusion');

# cargo
wfLoadExtension('Cargo');
$wgCargoDBtype = getenv('MEDIAWIKI_CARGO_TYPE');
$wgCargoDBserver = getenv('MEDIAWIKI_CARGO_SERVER');
$wgCargoDBname = getenv('MEDIAWIKI_CARGO_NAME');
$wgCargoDBuser = getenv('MEDIAWIKI_CARGO_USER');
$wgCargoDBpassword = getenv('MEDIAWIKI_CARGO_PASSWORD');
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

# SimpleMathJax - 3rd party extension
wfLoadExtension('SimpleMathJax');

# VariablesLua - 3rd party extension
wfLoadExtension('VariablesLua');

# CollapsibleVector fork
wfLoadExtension('CollapsibleVector-gbfwiki');

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
# DeletepagesFFS - 3rd party extension
/* wfLoadExtension('DeletePagesForGood');
$wgGroupPermissions['*']['deleteperm'] = false;
$wgGroupPermissions['user']['deleteperm'] = false;
$wgGroupPermissions['bureaucrat']['deleteperm'] = false;
$wgGroupPermissions['sysop']['deleteperm'] = true;
$wgDeletePagesForGoodNamespaces = array(
    'NS_MAIN' => true,
    'NS_IMAGE' => true,
    'NS_IMAGE_TALK' => true,
    'NS_CATEGORY' => true,
    'NS_CATEGORY_TALK' => true,
    'NS_TEMPLATE' => true,
    'NS_TEMPLATE_TALK' => true,
    'NS_TALK' => true,
    'NS_USER' => true,
    'NS_USER_TALK' => true,
    'NS_FILE' => true,
    'NS_FILE_TALK' => true,
    'NS_RAIDS' => true,
    'NS_RAIDS_TALK' => true,
    'NS_META' => true,
    'NS_META_TALK' => true,
    'NS_SCENARIO' => true,
    'NS_SCENARIO_TALK' => true,
    'NS_TOPIC' => true,
    #       'NS_TOPIC_TALK' => true,
    'NS_NEWS' => true,
    'NS_NEWS_TALK' => true,
    'NS_WIDGET' => true,
    'NS_TROPHIES' => true,
);
 */