<?php
// Run during the image build, with the final configuration and runtime user.
function check(bool $condition, string $message): void {
    if (!$condition) {
        throw new RuntimeException($message);
    }
}

check(PHP_VERSION_ID >= 80427 && PHP_VERSION_ID < 80500, 'PHP 8.4.27 or newer in the 8.4 branch is required');
foreach ([
    'calendar', 'ctype', 'curl', 'dom', 'exif', 'fileinfo', 'filter', 'gd',
    'iconv', 'igbinary', 'intl', 'json', 'luasandbox', 'mbstring', 'msgpack',
    'mysqli', 'mysqlnd', 'openssl', 'pcntl', 'Phar', 'posix', 'redis', 'session',
    'SimpleXML', 'sockets', 'sodium', 'tokenizer', 'wikidiff2', 'xml',
    'xmlreader', 'xmlwriter', 'Zend OPcache', 'zip',
] as $extension) {
    check(extension_loaded($extension), "Missing extension: $extension");
}
check(!ini_get('session.upload_progress.enabled'), 'Session upload progress must stay disabled');
check((int)(new LuaSandbox)->loadString('return 6 * 7')->call()[0] === 42, 'LuaSandbox execution failed');
check(str_contains(wikidiff2_do_diff("before\n", "after\n", 2), 'after'), 'wikidiff2 execution failed');

$value = ['text' => 'wiki', 'values' => [1, 2, 3]];
check(igbinary_unserialize(igbinary_serialize($value)) === $value, 'igbinary round trip failed');
check(msgpack_unpack(msgpack_pack($value)) === $value, 'MessagePack round trip failed');
foreach (['SERIALIZER_IGBINARY', 'SERIALIZER_MSGPACK', 'COMPRESSION_LZ4', 'COMPRESSION_LZF', 'COMPRESSION_ZSTD'] as $feature) {
    check(defined("Redis::$feature"), "Missing Redis feature: $feature");
}
check(Normalizer::normalize("e\u{0301}") === "\u{00e9}", 'ICU normalization failed');
check((string)simplexml_load_string('<root>ok</root>') === 'ok', 'XML parsing failed');
check(mb_strlen('日本語', 'UTF-8') === 3, 'Multibyte string handling failed');
check(preg_replace('/[0-9]+/', 'ok', '123') === 'ok', 'PCRE execution failed');

$image = imagecreatetruecolor(16, 16);
ob_start();
imagepng($image);
$png = ob_get_clean();
check(str_starts_with($png, "\x89PNG"), 'GD PNG generation failed');
foreach (['JPEG Support', 'WebP Support', 'AVIF Support', 'FreeType Support'] as $feature) {
    check(gd_info()[$feature] ?? false, "Missing GD feature: $feature");
}
check(curl_init() !== false, 'cURL initialization failed');
check(strlen(random_bytes(32)) === 32, 'Random byte generation failed');
check(strlen(sodium_crypto_generichash('wiki')) === 32, 'Sodium hashing failed');
echo 'PHP ', PHP_VERSION, " runtime checks passed\n";
