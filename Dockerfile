ARG ALPINE_VERSION=3.15
FROM alpine:${ALPINE_VERSION}
ENV MEDIAWIKI_MAJOR_VERSION=1.38
ENV MEDIAWIKI_VERSION=1.38.1
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki container with Nginx 1.20 & PHP 7.4 based on Alpine Linux 3.15."
WORKDIR /var/www/html

# install packages
RUN apk add --no-cache \
  curl \
  nginx \
  git \
  unzip \
  nano \
  lua5.1 \
  lua5.1-dev \
  # php
  php7 \
  php7-fpm \
  php7-curl \
  php7-ctype \
  php7-gd \
  php7-intl \
  php7-json \
  php7-iconv \
  php7-calendar \
  php7-pear \
  php7-fileinfo \
  php7-mbstring \
  php7-mysqli \
  php7-opcache \
  php7-tokenizer \
  php7-dev \
  php7-xmlwriter \
  php7-simplexml \
  php7-openssl \
  php7-phar \
  php7-session \
  php7-xml \
  php7-xmlreader \
  php7-zlib \
  php7-pecl-apcu \
  php7-pecl-xdebug \
  # mediawiki dependencies
  imagemagick \
  python3 \
  diffutils \
  composer \
  # build tools for luasandbox
  gcc \
  make \
  g++ \
  zlib-dev \
  # supervisor
  supervisor; \
  # download mediawiki
  curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz; \
	tar -x --strip-components=1 -f mediawiki.tar.gz; \
	# clean-up
	rm -rf mediawiki.tar.gz UPGRADE SECURITY RELEASE-NOTES-${MEDIAWIKI_MAJOR_VERSION} README.md INSTALL HISTORY FAQ CREDITS COPYING CODE_OF_CONDUCT.md; \
  # install extensions
  # ImportArticles
  git clone --branch REL1_38 http://gerrit.wikimedia.org/r/mediawiki/extensions/ImportArticles /var/www/html/extensions/ImportArticles; \
  # Variables
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Variables /var/www/html/extensions/Variables; \
  # Loops
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Loops /var/www/html/extensions/Loops; \
  # Arrays
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Arrays /var/www/html/extensions/Arrays; \
  # TemplateSandbox
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateSandbox /var/www/html/extensions/TemplateSandbox; \
  # WikiSEO
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/WikiSEO /var/www/html/extensions/WikiSEO; \
  # CheckUser
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser /var/www/html/extensions/CheckUser; \
  # Tabs
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Tabs /var/www/html/extensions/Tabs; \
  # Widgets
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets /var/www/html/extensions/Widgets; \
	cd /var/www/html/extensions/Widgets; \
	/usr/bin/php7 /usr/bin/composer.phar update; \
	cd /var/www/html; \
  # cldr
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/cldr /var/www/html/extensions/cldr; \
  # StructuredDiscussions
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Flow /var/www/html/extensions/Flow; \
  cd /var/www/html/extensions/Flow;/usr/bin/php7 /usr/bin/composer.phar update --no-dev; \
  # Echo
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Echo /var/www/html/extensions/Echo; \
  # LabeledSectionTransclusion
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/LabeledSectionTransclusion /var/www/html/extensions/LabeledSectionTransclusion; \
  # Cargo
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Cargo /var/www/html/extensions/Cargo; \
  # VariablesLua
  git clone https://github.com/Liquipedia/VariablesLua /var/www/html/extensions/VariablesLua; \
  # LuaSandbox
  pecl channel-update pecl.php.net; \
	pecl install luasandbox; \
  # Tabber
  git clone --branch REL1_38 https://gerrit.wikimedia.org/r/mediawiki/extensions/Tabber /var/www/html/extensions/Tabber; \
  # DPL3
  curl -fSL "https://github.com/Universal-Omega/DynamicPageList3/archive/REL1_35.tar.gz/" -o REL1_35.tar.gz; \
	tar -xzf REL1_35.tar.gz -C /var/www/html/extensions;mv /var/www/html/extensions/DynamicPageList3-REL1_35 /var/www/html/extensions/DynamicPageList3;rm REL1_35.tar.gz; \
  # composer
  cd /var/www/html;/usr/bin/php7 /usr/bin/composer.phar update --no-dev; \
  # uninstall build tools
  apk del gcc make g++ zlib-dev lua5.1-dev; \
  # fix permissions
  chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx;

USER nobody

# copy nginx.conf
COPY config/nginx.conf /etc/nginx/nginx.conf

# copy php-fpm configuration
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini
COPY config/luasandbox.ini /etc/php7/conf.d/luasandbox.ini
COPY config/xdebug.ini /etc/php7/conf.d/xdebug.ini
COPY config/opcache.ini /etc/php7/conf.d/opcache.ini

# copy supervisord.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy LocalSettings
COPY --chown=nobody:nobody config/LocalSettings.php /var/www/html/LocalSettings.php
COPY --chown=nobody:nobody config/LocalSettings_extensions.php /var/www/html/LocalSettings_extensions.php

# expose port 8080
EXPOSE 8080

# bring up supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]