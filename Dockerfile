FROM alpine:3.24 AS wikidiff2-builder

RUN apk add --no-cache \
        build-base \
        git \
        libthai-dev \
        php84-dev \
    && git clone https://gerrit.wikimedia.org/r/mediawiki/php/wikidiff2 \
    && cd wikidiff2 \
    && git checkout 532129cb4f51f10acc62f97f84b3055132912af0 \
    && phpize84 \
    && ./configure --prefix=/usr --with-php-config=php-config84 \
    && make \
    && make install

FROM alpine:3.24 AS mediawiki-builder

ARG MEDIAWIKI_MAJOR_VERSION=1.46
ARG MEDIAWIKI_VERSION=1.46.0
ARG MEDIAWIKI_SHA256=ac395e4ffd3b63b86a242efd679257503e463445ba9f989b514d9d3b342c456a
ENV COMPOSER_ROOT_VERSION=${MEDIAWIKI_VERSION}
WORKDIR /var/www/html

RUN apk add --no-cache \
        composer \
        curl \
        git \
        patch \
        php84 \
        php84-curl \
        php84-iconv \
        php84-mbstring \
        php84-openssl \
        php84-phar \
        php84-tokenizer \
        php84-xml \
        php84-zip \
        unzip

# download and extract MediaWiki
RUN curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz && \
  echo "${MEDIAWIKI_SHA256}  mediawiki.tar.gz" | sha256sum -c - && \
  tar -x --strip-components=1 -f mediawiki.tar.gz && \
  # clean
  rm -rf \
    mediawiki.tar.gz \
    UPGRADE SECURITY RELEASE-NOTES-* README.md INSTALL HISTORY FAQ CREDITS COPYING CODE_OF_CONDUCT.md \
    /var/cache/apk/* \
    /tmp/* \
    /var/tmp/*

# Backport https://gerrit.wikimedia.org/r/c/mediawiki/core/+/1307629
COPY patches/mediawiki-1307629.patch /tmp/mediawiki-1307629.patch
RUN patch -p1 < /tmp/mediawiki-1307629.patch && rm /tmp/mediawiki-1307629.patch

# composer
COPY composer.json /var/www/html/composer.local.json
COPY composer.lock /var/www/html/composer.lock
RUN /usr/bin/php84 /usr/bin/composer.phar config --no-plugins allow-plugins.composer/installers true && \
    /usr/bin/php84 /usr/bin/composer.phar install --no-dev \
        --ignore-platform-reqs \
        --no-ansi \
        --no-interaction \
        --no-scripts

FROM alpine:3.24

ENV MEDIAWIKI_MAJOR_VERSION=1.46
ENV MEDIAWIKI_VERSION=1.46.0
ENV COMPOSER_ROOT_VERSION=${MEDIAWIKI_VERSION}
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki 1.46.0 container with Nginx 1.30.4 & PHP 8.4 based on Alpine Linux 3.24"
WORKDIR /var/www/html

RUN apk add --no-cache \
  curl \
  imagemagick \
  libgcc \
  libstdc++ \
  libthai \
  lua5.1 \
  nginx \
  php84 \
  php84-calendar \
  php84-ctype \
  php84-curl \
  php84-exif \
  php84-fileinfo \
  php84-fpm \
  php84-gd \
  php84-iconv \
  php84-intl \
  php84-mbstring \
  php84-mysqli \
  php84-opcache \
  php84-openssl \
  php84-pcntl \
  php84-pecl-luasandbox \
  php84-pecl-redis \
  php84-phar \
  php84-posix \
  php84-session \
  php84-simplexml \
  php84-sodium \
  php84-tokenizer \
  php84-xml \
  php84-xmlreader \
  php84-xmlwriter \
  vips-tools

COPY --from=mediawiki-builder --chown=nobody:nobody /var/www/html /var/www/html
COPY --from=wikidiff2-builder /usr/lib/php84/modules/wikidiff2.so /usr/lib/php84/modules/wikidiff2.so

RUN chown -R nobody:nobody /run /var/lib/nginx /var/log
USER nobody

# copy config
COPY --chmod=755 config/entrypoint /usr/local/bin/entrypoint
# COPY config/nginx.conf /etc/nginx/nginx.conf
# COPY config/php/fpm-pool.conf /etc/php84/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php84/conf.d/00-custom.ini
COPY config/php/luasandbox.ini /etc/php84/conf.d/luasandbox.ini
COPY config/php/opcache.ini /etc/php84/conf.d/opcache.ini
COPY config/php/wikidiff2.ini /etc/php84/conf.d/wikidiff2.ini

# copy resources
COPY resource/robots.txt /var/www/html/robots.txt
COPY resource/favicon.ico /var/www/html/favicon.ico

# expose port 8080
EXPOSE 8080

# bring up nginx and PHP-FPM
CMD ["/usr/local/bin/entrypoint"]
