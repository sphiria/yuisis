FROM alpine:3.21.5
ENV MEDIAWIKI_MAJOR_VERSION=1.43
ENV MEDIAWIKI_VERSION=1.43.6
ENV COMPOSER_ROOT_VERSION=${MEDIAWIKI_VERSION}
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki 1.43.6 container with Nginx 1.26 & PHP 8.3 based on Alpine Linux 3.21.5"
WORKDIR /var/www/html

# install packages
RUN apk add --no-cache \
  composer \
  curl \
  diffutils \
  git \
  imagemagick \
  lua5.1 \
  lua5.1-dev \
  libthai-dev \
  nginx \
  php83 \
  php83-calendar \
  php83-ctype \
  php83-curl \
  php83-dev \
  php83-exif \
  php83-fileinfo \
  php83-fpm \
  php83-gd \
  php83-iconv \
  php83-intl \
  php83-json \
  php83-mbstring \
  php83-mysqli \
  php83-opcache \
  php83-openssl \
  php83-pcntl \
  php83-pecl-luasandbox \
  php83-pecl-redis \
  php83-pear \
  php83-phar \
  php83-posix \
  php83-session \
  php83-simplexml \
  php83-sodium \
  php83-tokenizer \
  php83-xml \
  php83-xmlreader \
  php83-xmlwriter \
  php83-zlib \
  build-base \
  python3 \
  supervisor \
  unzip \
  vips-tools

# wikidiff2
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        git \
    && git clone https://gerrit.wikimedia.org/r/mediawiki/php/wikidiff2 \
    && cd wikidiff2 \
    && phpize \
    && ./configure --prefix=/usr --with-php-config=php-config83 \
    && make \
    && make install \
    && cd .. \
    && rm -rf wikidiff2 \
    && apk del .build-deps

# download and extract MediaWiki
RUN mkdir /.composer && chown -R nobody:nobody /var/www/html /run /var/lib/nginx /var/log /.composer
USER nobody
RUN curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz && \
  tar -x --strip-components=1 -f mediawiki.tar.gz && \
  # clean
  rm -rf \
    mediawiki.tar.gz \
    UPGRADE SECURITY RELEASE-NOTES-* README.md INSTALL HISTORY FAQ CREDITS COPYING CODE_OF_CONDUCT.md \
    /var/cache/apk/* \
    /tmp/* \
    /var/tmp/*

# composer
COPY composer.json /var/www/html/composer.local.json
RUN /usr/bin/php83 /usr/bin/composer.phar config --no-plugins allow-plugins.composer/installers true && \
    /usr/bin/php83 /usr/bin/composer.phar install --no-dev \
        --ignore-platform-reqs \
        --no-ansi \
        --no-interaction \
        --no-scripts && \
    /usr/bin/php83 /usr/bin/composer.phar update --no-dev \
        --no-ansi \
        --no-interaction \
        --no-scripts && \
    # clean up composer cache
    rm -rf /.composer/cache/*

# fix folder names
RUN cd /var/www/html/extensions \
    && mv Vipsscaler VipsScaler \
    && mv Wikiseo WikiSEO \
    && mv Webauthn WebAuthn \
    && mv Oauth OAuth \
    && mv Cirrussearch CirrusSearch \
    && mv Variableslua VariablesLua \
    && mv Templatesandbox TemplateSandbox \
    && mv Simplemathjax SimpleMathJax \
    && mv Randomselection RandomSelection \
    && mv Regexfunctions RegexFunctions \
    && mv MwDiscord Discord \
    && mv Importarticles ImportArticles \
    && mv Labeledsectiontransclusion LabeledSectionTransclusion \
    && mv Msupload MsUpload \
    && mv Checkuser CheckUser \
    && mv Deletepagesforgood DeletePagesForGood \
    && mv Darkmode DarkMode \
    && mv Cldr cldr \
    && mv Shortdescription ShortDescription

# copy config
COPY config/jobrunner /var/www/jobrunner
COPY config/searchrunner /var/www/searchrunner
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/php/fpm-pool.conf /etc/php83/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php83/conf.d/00-custom.ini
COPY config/php/luasandbox.ini /etc/php83/conf.d/luasandbox.ini
COPY config/php/opcache.ini /etc/php83/conf.d/opcache.ini
COPY config/php/wikidiff2.ini /etc/php83/conf.d/wikidiff2.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy resources
COPY resource/robots.txt /var/www/html/robots.txt
COPY resource/favicon.ico /var/www/html/favicon.ico

# expose port 8080
EXPOSE 8080

# bring up supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]