FROM alpine:3.24 AS php-builder

ARG PHP_VERSION=8.4.27
ARG PHP_SHA256=dcf93923b0e38e0d5252b25b796520b5a47761a08b3488b6d0b5d1115764d3f0
ARG PHP_BUILD_JOBS=2

RUN apk add --no-cache \
        autoconf bison build-base curl linux-headers pax-utils pkgconf re2c xz \
        argon2-dev curl-dev freetype-dev icu-dev libavif-dev libjpeg-turbo-dev \
        libpng-dev libsodium-dev libwebp-dev libxml2-dev libxpm-dev libzip-dev \
        lua5.1-dev lz4-dev oniguruma-dev openssl-dev pcre2-dev zlib-dev zstd-dev
COPY config/php/build-source.sh /tmp/build-php.sh
RUN sh /tmp/build-php.sh

FROM alpine:3.24 AS php-runtime
COPY --from=php-builder /opt/php-runtime/ /
COPY --from=php-builder /opt/php-runtime-deps /tmp/php-runtime-deps
RUN xargs apk add --no-cache ca-certificates icu-data-full < /tmp/php-runtime-deps && \
    rm /tmp/php-runtime-deps && \
    php84 -r 'exit(PHP_VERSION_ID >= 80427 && PHP_VERSION_ID < 80500 ? 0 : 1);'

FROM php-builder AS wikidiff2-builder

RUN apk add --no-cache \
        build-base \
        git \
        libthai-dev \
    && git clone https://gerrit.wikimedia.org/r/mediawiki/php/wikidiff2 \
    && cd wikidiff2 \
    && git checkout 532129cb4f51f10acc62f97f84b3055132912af0 \
    && phpize84 \
    && ./configure --prefix=/usr --with-php-config=php-config84 \
    && make \
    && make install

FROM alpine:3.24 AS hardened-malloc-builder

ARG HARDENED_MALLOC_REVISION=bf37d54560a62b50da72e8fda56abf04f23b5fd2
ARG HARDENED_MALLOC_SHA256=f18cdef6947a298cf80ed42af94f0f45f3e6617131d4330dc1e4c0c674a73d4a

RUN apk add --no-cache build-base curl && \
    curl --fail --location --retry 3 \
      "https://codeload.github.com/GrapheneOS/hardened_malloc/tar.gz/${HARDENED_MALLOC_REVISION}" \
      -o /tmp/hardened-malloc.tar.gz && \
    echo "${HARDENED_MALLOC_SHA256}  /tmp/hardened-malloc.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/hardened-malloc && \
    tar -xzf /tmp/hardened-malloc.tar.gz -C /tmp/hardened-malloc --strip-components=1 && \
    make -C /tmp/hardened-malloc -j2 CONFIG_NATIVE=false

FROM alpine:3.24 AS jobchron-builder

ARG JOBRUNNER_REVISION=09f30782077b6101871fa95715f7181391d20486
ARG JOBRUNNER_SHA256=2c48853a607e51b14381e78e8d8107d1b47d706b57024ec53500ba9cc28b595a

RUN apk add --no-cache curl && \
    curl --fail --location --retry 3 \
      "https://codeload.github.com/wikimedia/mediawiki-services-jobrunner/tar.gz/${JOBRUNNER_REVISION}" \
      -o /tmp/jobrunner.tar.gz && \
    echo "${JOBRUNNER_SHA256}  /tmp/jobrunner.tar.gz" | sha256sum -c - && \
    mkdir -p /opt/jobchron/upstream && \
    tar -xzf /tmp/jobrunner.tar.gz -C /opt/jobchron/upstream --strip-components=1 \
      "mediawiki-services-jobrunner-${JOBRUNNER_REVISION}/COPYING" \
      "mediawiki-services-jobrunner-${JOBRUNNER_REVISION}/src/RedisJobChronService.php" \
      "mediawiki-services-jobrunner-${JOBRUNNER_REVISION}/src/RedisJobService.php" \
      "mediawiki-services-jobrunner-${JOBRUNNER_REVISION}/src/RedisExceptionHA.php" \
      "mediawiki-services-jobrunner-${JOBRUNNER_REVISION}/src/PeriodicScriptParamsIterator.php" && \
    rm /tmp/jobrunner.tar.gz

COPY config/jobchron.php /opt/jobchron/run.php

FROM php-runtime AS mediawiki-source

ARG COMPOSER_VERSION=2.10.3
ARG COMPOSER_SHA256=7a2d379d5b8ffdaa028580ef26494c36d2feef4b178d3dd1473a4dbc5e17c8d6
ARG MEDIAWIKI_MAJOR_VERSION=1.46
ARG MEDIAWIKI_VERSION=1.46.2
ARG MEDIAWIKI_SHA256=8f7f937f8bbc1acd4cef1c5362a95f248dcd242020f2588798eb2f73ac2e69ba
ENV COMPOSER_ROOT_VERSION=${MEDIAWIKI_VERSION}
WORKDIR /var/www/html

RUN apk add --no-cache curl git patch unzip && \
    curl --fail --location --retry 3 \
      "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
      -o /usr/bin/composer.phar && \
    echo "${COMPOSER_SHA256}  /usr/bin/composer.phar" | sha256sum -c -

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

COPY patches/mediawiki-security-composer.patch /tmp/mediawiki-security-composer.patch
RUN patch -p1 < /tmp/mediawiki-security-composer.patch && rm /tmp/mediawiki-security-composer.patch

FROM mediawiki-source AS mediawiki-builder

ENV COMPOSER_ALLOW_SUPERUSER=1

# composer
COPY composer.json /var/www/html/composer.local.json
COPY composer.lock /var/www/html/composer.lock
RUN /usr/bin/php84 /usr/bin/composer.phar config --no-plugins allow-plugins.composer/installers true && \
    /usr/bin/php84 /usr/bin/composer.phar install --no-dev \
        --prefer-dist \
        --ignore-platform-reqs \
        --no-ansi \
        --no-interaction \
        --no-scripts && \
    /usr/bin/php84 /usr/bin/composer.phar check-platform-reqs --no-dev

COPY patches/multipurge-page-title.patch /tmp/multipurge-page-title.patch
RUN patch -p1 < /tmp/multipurge-page-title.patch && rm /tmp/multipurge-page-title.patch

FROM php-runtime AS runtime

ENV MEDIAWIKI_MAJOR_VERSION=1.46
ENV MEDIAWIKI_VERSION=1.46.2
ENV COMPOSER_ROOT_VERSION=${MEDIAWIKI_VERSION}
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki 1.46.2 container with Nginx 1.30.4 & PHP 8.4 based on Alpine Linux 3.24"
WORKDIR /var/www/html

RUN apk add --no-cache \
  curl \
  imagemagick \
  libgcc \
  libstdc++ \
  libthai \
  lua5.1 \
  nginx \
  vips-tools

COPY --from=mediawiki-builder --chown=root:root /var/www/html /var/www/html
COPY --from=wikidiff2-builder /usr/lib/php84/modules/wikidiff2.so /usr/lib/php84/modules/wikidiff2.so
COPY --from=jobchron-builder /opt/jobchron /opt/jobchron

# widgets
RUN chmod -R go-w /var/www/html && \
    mkdir -p /var/www/html/extensions/Widgets/compiled_templates && \
    chown nobody:nobody /var/www/html/extensions/Widgets/compiled_templates && \
    chown -R nobody:nobody /run /var/lib/nginx /var/log
USER nobody

# copy config
COPY --chmod=755 config/entrypoint /usr/local/bin/entrypoint
COPY config/php/php.ini /etc/php84/conf.d/00-custom.ini
COPY config/php/luasandbox.ini /etc/php84/conf.d/luasandbox.ini
COPY config/php/opcache.ini /etc/php84/conf.d/opcache.ini
COPY config/php/wikidiff2.ini /etc/php84/conf.d/wikidiff2.ini
COPY config/php/check-runtime.php /tmp/check-php-runtime.php
RUN php84 /tmp/check-php-runtime.php && php-fpm84 -tt

# copy resources
COPY resource/robots.txt /var/www/html/robots.txt
COPY resource/favicon.ico /var/www/html/favicon.ico

# expose port 8080
EXPOSE 8080

# bring up nginx and PHP-FPM
CMD ["/usr/local/bin/entrypoint"]

# hardened malloc
FROM runtime AS hardened-malloc
COPY --from=hardened-malloc-builder --chmod=755 /tmp/hardened-malloc/out/libhardened_malloc.so /usr/local/lib/libhardened_malloc.so
COPY --from=hardened-malloc-builder /tmp/hardened-malloc/LICENSE /usr/share/licenses/hardened-malloc/LICENSE
ENV LD_PRELOAD=/usr/local/lib/libhardened_malloc.so

FROM runtime AS release
