ARG ALPINE_VERSION=3.17
FROM alpine:${ALPINE_VERSION}
ENV MEDIAWIKI_MAJOR_VERSION=1.39
ENV MEDIAWIKI_VERSION=1.39.2
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki container with Nginx 1.22 & PHP 8.1 based on Alpine Linux 3.17."
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
  php81 \
  php81-fpm \
  php81-curl \
  php81-ctype \
  php81-gd \
  php81-intl \
  php81-json \
  php81-iconv \
  php81-calendar \
  php81-pear \
  php81-fileinfo \
  php81-mbstring \
  php81-mysqli \
  php81-opcache \
  php81-tokenizer \
  php81-dev \
  php81-xmlwriter \
  php81-simplexml \
  php81-openssl \
  php81-phar \
  php81-session \
  php81-xml \
  php81-xmlreader \
  php81-zlib \
  php81-pecl-apcu \
  php81-pecl-xdebug \
  php81-pecl-redis \
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
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/ImportArticles /var/www/html/extensions/ImportArticles; \
  # Variables
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Variables /var/www/html/extensions/Variables; \
  # Loops
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Loops /var/www/html/extensions/Loops; \
  # Arrays
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Arrays /var/www/html/extensions/Arrays; \
  # TemplateSandbox
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateSandbox /var/www/html/extensions/TemplateSandbox; \
  # WikiSEO
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/WikiSEO /var/www/html/extensions/WikiSEO; \
  # CheckUser
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser /var/www/html/extensions/CheckUser; \
  # Tabs
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Tabs /var/www/html/extensions/Tabs; \
  # Widgets
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets /var/www/html/extensions/Widgets; \
	cd /var/www/html/extensions/Widgets; \
	/usr/bin/php81 /usr/bin/composer.phar update; \
	cd /var/www/html; \
  # cldr
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/cldr /var/www/html/extensions/cldr; \
  # StructuredDiscussions
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Flow /var/www/html/extensions/Flow; \
  cd /var/www/html/extensions/Flow;/usr/bin/php81 /usr/bin/composer.phar update --no-dev; \
  # Echo
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Echo /var/www/html/extensions/Echo; \
  # CollapsibleVector-gbfwiki
  git clone https://github.com/sphiria/CollapsibleVector-gbfwiki /var/www/html/extensions/CollapsibleVector-gbfwiki; \
  # LabeledSectionTransclusion
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/LabeledSectionTransclusion /var/www/html/extensions/LabeledSectionTransclusion; \
  # CodeMirror
  git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/CodeMirror /var/www/html/extensions/CodeMirror; \
  # Cargo
  git clone https://github.com/wikimedia/mediawiki-extensions-Cargo /var/www/html/extensions/Cargo; \
  # VariablesLua
  git clone https://github.com/Liquipedia/VariablesLua /var/www/html/extensions/VariablesLua; \
  # LuaSandbox
  pecl channel-update pecl.php.net; \
	pecl install luasandbox; \
  # SimpleMathJax
  git clone https://github.com/jmnote/SimpleMathJax /var/www/html/extensions/SimpleMathJax; \
  # Tabber
  git clone https://gitlab.com/hydrawiki/extensions/Tabber /var/www/html/extensions/Tabber; \
  #git clone https://github.com/StarCitizenTools/mediawiki-extensions-TabberNeue.git /var/www/html/extensions/TabberNeue; \
  # DPL3
  git clone https://github.com/Universal-Omega/DynamicPageList3 /var/www/html/extensions/DynamicPageList3; \
  # Popups
  # git clone --branch REL1_39 https://gerrit.wikimedia.org/r/mediawiki/extensions/Popups /var/www/html/extensions/Popups; \
  # skin
  git clone https://github.com/StarCitizenTools/mediawiki-skins-Citizen /var/www/html/skins/Citizen; \
  # composer
  cd /var/www/html;/usr/bin/php81 /usr/bin/composer.phar update --no-dev; \
  # uninstall build tools
  apk del gcc make g++ zlib-dev lua5.1-dev; \
  # nuke images folder for mounting it later
  rm -rf /var/www/html/images; \
  ln -s /mnt/zooey/images /var/www/html/images; \
  # fix permissions
  chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx;

USER nobody

# copy nginx.conf
COPY config/nginx.conf /etc/nginx/nginx.conf

# copy php-fpm configuration
COPY config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY config/php.ini /etc/php81/conf.d/custom.ini
COPY config/luasandbox.ini /etc/php81/conf.d/luasandbox.ini
COPY config/opcache.ini /etc/php81/conf.d/opcache.ini

# copy supervisord.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy LocalSettings
COPY --chown=nobody:nobody config/LocalSettings.php /var/www/html/LocalSettings.php
COPY --chown=nobody:nobody config/LocalSettings_extensions.php /var/www/html/LocalSettings_extensions.php

# expose port 8080
EXPOSE 8080

# bring up supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]