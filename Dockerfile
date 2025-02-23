FROM alpine:3.21.2
ENV MEDIAWIKI_MAJOR_VERSION=1.43
ENV MEDIAWIKI_VERSION=1.43.0
ENV COMPOSER_ROOT_VERSION=${MEDIAWIKI_VERSION}
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki 1.43.0 container with Nginx 1.26 & PHP 8.4 based on Alpine Linux 3.21.2"
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
  nginx \
  php84-common \
  php84-calendar \
  php84-ctype \
  php84-curl \
  php84-dev \
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
  php83-pecl-luasandbox \
  php84-pecl-redis \
  php84-pear \
  php84-phar \
  php84-posix \
  php84-session \
  php84-simplexml \
  php84-sodium \
  php84-tokenizer \
  php84-xml \
  php84-xmlreader \
  php84-xmlwriter \
  python3 \
  supervisor \
  unzip \
  vips-tools && \
  # download and extract MediaWiki
  curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz && \
  tar -x --strip-components=1 -f mediawiki.tar.gz && \
  # clean
  rm -rf \
    mediawiki.tar.gz \
    UPGRADE SECURITY RELEASE-NOTES-* README.md INSTALL HISTORY FAQ CREDITS COPYING CODE_OF_CONDUCT.md \
    /var/cache/apk/* \
    /tmp/* \
    /var/tmp/*

# composer
COPY config/composer.local.json /var/www/html/composer.local.json
RUN /usr/bin/php84 /usr/bin/composer.phar config --no-plugins allow-plugins.composer/installers true && \
    /usr/bin/php84 /usr/bin/composer.phar install --no-dev \
        --ignore-platform-reqs \
        --no-ansi \
        --no-interaction \
        --no-scripts && \
    /usr/bin/php84 /usr/bin/composer.phar update --no-dev \
        --no-ansi \
        --no-interaction \
        --no-scripts && \
    # clean up composer cache
    rm -rf /root/.composer/cache/*

# set permissions
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx /var/log/php84
# drop to low user    
USER nobody

# fix folder names
RUN cd /var/www/html/extensions && \
    mv Vipsscaler VipsScaler && \
    mv Wikiseo WikiSEO && \
    mv Webauthn WebAuthn && \
    mv Oauth OAuth && \
    mv Cirrussearch CirrusSearch && \
    mv Variableslua VariablesLua && \
    mv Templatesandbox TemplateSandbox && \
    mv Simplemathjax SimpleMathJax && \
    mv Randomselection RandomSelection && \
    mv Regexfunctions RegexFunctions && \
    mv MwDiscord Discord && \
    mv Importarticles ImportArticles && \
    mv Labeledsectiontransclusion LabeledSectionTransclusion && \
    mv Msupload MsUpload && \
    mv Checkuser CheckUser && \
    mv Deletepagesforgood DeletePagesForGood && \
    mv Darkmode DarkMode && \
    mv Cldr cldr && \
    mv Shortdescription ShortDescription

# copy config
COPY config/jobrunner /var/www/jobrunner
COPY config/searchrunner /var/www/searchrunner
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/php/fpm-pool.conf /etc/php83/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php83/conf.d/custom.ini
COPY config/php/luasandbox.ini /etc/php83/conf.d/luasandbox.ini
COPY config/php/opcache.ini /etc/php83/conf.d/opcache.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy resources
COPY resource/robots.txt /var/www/html/robots.txt
COPY resource/favicon.ico /var/www/html/favicon.ico

# expose port 8080
EXPOSE 8080

# bring up supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]