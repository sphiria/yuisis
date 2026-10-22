#!/bin/sh
set -eu
umask 022

: "${PHP_VERSION:?PHP_VERSION is required}"
: "${PHP_SHA256:?PHP_SHA256 is required}"
jobs=${PHP_BUILD_JOBS:-2}
work=/tmp/php-build
mkdir -p "$work"
cd "$work"

curl --fail --location --retry 3 "https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz" -o php.tar.xz
echo "$PHP_SHA256  php.tar.xz" | sha256sum -c -
mkdir php
tar -xJf php.tar.xz -C php --strip-components=1
cd php

# Keep the existing Alpine binary, configuration and extension paths.
export EXTENSION_DIR=/usr/lib/php84/modules
export CFLAGS='-O2 -fstack-protector-strong -fstack-clash-protection -fPIC'
export CXXFLAGS="$CFLAGS"
export LDFLAGS='-Wl,-z,relro,-z,now'
./configure \
    --prefix=/usr --program-suffix=84 --libdir=/usr/lib/php84 \
    --datadir=/usr/share/php84 --sysconfdir=/etc/php84 --localstatedir=/var \
    --with-layout=GNU --with-pic --disable-rpath --disable-short-tags \
    --with-config-file-path=/etc/php84 --with-config-file-scan-dir=/etc/php84/conf.d \
    --disable-cgi --disable-phpdbg --without-pear \
    --enable-fpm --with-fpm-user=nobody --with-fpm-group=nobody \
    --with-curl --with-libxml --with-zlib --with-external-pcre \
    --enable-calendar --enable-ctype --enable-dom --enable-exif --enable-fileinfo \
    --enable-filter --enable-gd --with-avif --with-freetype --with-jpeg --with-webp --with-xpm \
    --with-iconv --enable-intl --enable-mbstring \
    --enable-mysqlnd --with-mysqli=mysqlnd \
    --with-openssl --with-password-argon2 --with-sodium \
    --enable-pcntl --enable-posix --enable-session --enable-phar \
    --enable-simplexml --enable-sockets --enable-tokenizer \
    --enable-xml --enable-xmlreader --enable-xmlwriter --with-zip \
    --enable-opcache --disable-pdo --without-pdo-sqlite --without-sqlite3
make -j"$jobs"
make install
install -Dm644 php.ini-production /etc/php84/php.ini

build_extension() {
    name=$1
    checksum=$2
    shift 2
    build_extension_from_url "$name" "$checksum" "https://pecl.php.net/get/${name}.tgz" "$@"
}

build_extension_from_url() {
    name=$1
    checksum=$2
    source_url=$3
    shift 3
    cd "$work"
    curl --fail --location --retry 3 "$source_url" -o "$name.tgz"
    echo "$checksum  $name.tgz" | sha256sum -c -
    mkdir "$name"
    tar -xzf "$name.tgz" -C "$name" --strip-components=1
    cd "$name"
    phpize84
    ./configure --prefix=/usr --with-php-config=/usr/bin/php-config84 "$@"
    make -j"$jobs"
    make install
}

build_extension igbinary-3.2.17RC1 91da821443db125282a6aea039f24588dd28ff5d71e8187f6ecc41165bceafbc
build_extension msgpack-3.0.1 e30be355ab79aaea4568692fbd6073fd7c7f50ea8d3cf12edce40fc0c921d868
build_extension_from_url LuaSandbox-4.1.4 \
    154571b700b7534a083b002df583e0da95450b1a39f8685f50aa4cafded8e28a \
    https://github.com/wikimedia/mediawiki-php-luasandbox/archive/refs/tags/4.1.4.tar.gz
build_extension redis-6.3.0 0d5141f634bd1db6c1ddcda053d25ecf2c4fc1c395430d534fd3f8d51dd7f0b5 \
    --enable-redis-igbinary --enable-redis-msgpack \
    --enable-redis-lz4 --with-liblz4 --enable-redis-lzf --enable-redis-zstd

mkdir -p /etc/php84/conf.d /etc/php84/php-fpm.d
printf 'zend_extension=opcache.so\n' > /etc/php84/conf.d/00-opcache.ini
printf 'extension=igbinary.so\n' > /etc/php84/conf.d/10-igbinary.ini
printf 'extension=msgpack.so\n' > /etc/php84/conf.d/10-msgpack.ini
printf 'extension=redis.so\n' > /etc/php84/conf.d/20-redis.ini
cat > /etc/php84/php-fpm.conf <<'EOF'
[global]
error_log = /dev/stderr
include = /etc/php84/php-fpm.d/*.conf
EOF
cat > /etc/php84/php-fpm.d/www.conf <<'EOF'
[www]
user = nobody
group = nobody
listen = 127.0.0.1:9000
pm = ondemand
pm.max_children = 5
catch_workers_output = yes
EOF

payload=/opt/php-runtime
mkdir -p "$payload/usr/bin" "$payload/usr/sbin" "$payload/usr/lib/php84" "$payload/etc/php84"
install -m755 /usr/bin/php84 "$payload/usr/bin/php84"
install -m755 /usr/sbin/php-fpm84 "$payload/usr/sbin/php-fpm84"
ln -s php84 "$payload/usr/bin/php"
cp -a /usr/lib/php84/modules "$payload/usr/lib/php84/"
cp -a /etc/php84/. "$payload/etc/php84/"
for project in php igbinary-3.2.17RC1 msgpack-3.0.1 LuaSandbox-4.1.4 redis-6.3.0; do
    mkdir -p "$payload/usr/share/licenses/$project"
    find "$work/$project" -maxdepth 1 -type f \( -iname '*license*' -o -name COPYING \) \
        -exec cp '{}' "$payload/usr/share/licenses/$project/" \;
done
strip /opt/php-runtime/usr/bin/php84 /opt/php-runtime/usr/sbin/php-fpm84 /opt/php-runtime/usr/lib/php84/modules/*.so
scanelf --needed --nobanner --format '%n#p' --recursive "$payload/usr" \
    | tr ',' '\n' | sed '/^$/d; s/^/so:/' | sort -u > /opt/php-runtime-deps
