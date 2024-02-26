ARG ALPINE_VERSION=3.19.1
FROM alpine:${ALPINE_VERSION}
ENV MEDIAWIKI_MAJOR_VERSION=1.41
ENV MEDIAWIKI_VERSION=1.41.0
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki 1.41.0 container with Nginx 1.24 & PHP 8.3 based on Alpine Linux 3.19.1"
WORKDIR /var/www/html

# install packages
RUN apk add --no-cache \
  curl \
  nginx \
  git \
  unzip \
  nano \
  vips-tools \ 
  lua5.1 \
  lua5.1-dev \
  # php
  php83 \
  php83-fpm \
  php83-curl \
  php83-ctype \
  php83-gd \
  php83-intl \
  php83-json \
  php83-iconv \
  php83-calendar \
  php83-pear \
  php83-fileinfo \
  php83-mbstring \
  php83-mysqli \
  php83-opcache \
  php83-tokenizer \
  php83-dev \
  php83-xmlwriter \
  php83-simplexml \
  php83-openssl \
  php83-phar \
  php83-session \
  php83-xml \
  php83-xmlreader \
  php83-zlib \
  php83-pecl-apcu \
  php83-pecl-xdebug \
  php83-pecl-redis \
  php83-pecl-luasandbox \
  # mediawiki dependencies
  imagemagick \
  python3 \
  diffutils \
  composer \
  # supervisor
  supervisor; \
  # download mediawiki
  curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz; \
	tar -x --strip-components=1 -f mediawiki.tar.gz; \
	# clean-up
	rm -rf mediawiki.tar.gz UPGRADE SECURITY RELEASE-NOTES-${MEDIAWIKI_MAJOR_VERSION} README.md INSTALL HISTORY FAQ CREDITS COPYING CODE_OF_CONDUCT.md; \
  # install extensions
  # ImportArticles
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/ImportArticles /var/www/html/extensions/ImportArticles; \
  # Variables
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/Variables /var/www/html/extensions/Variables; \
  # Loops
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/Loops /var/www/html/extensions/Loops; \
  # Arrays
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/Arrays /var/www/html/extensions/Arrays; \
  # TemplateSandbox
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateSandbox /var/www/html/extensions/TemplateSandbox; \
  # ShortDescription
  git clone https://github.com/StarCitizenTools/mediawiki-extensions-ShortDescription /var/www/html/extensions/ShortDescription; \
  # UploadWizard
  git clone --branch REL1_41 https://github.com/sphiria/mediawiki-extensions-UploadWizard /var/www/html/extensions/UploadWizard; \
  # WikiSEO
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/WikiSEO /var/www/html/extensions/WikiSEO; \
  # CheckUser
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser /var/www/html/extensions/CheckUser; \
  # Tabs
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/Tabs /var/www/html/extensions/Tabs; \
  # Widgets
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets /var/www/html/extensions/Widgets; \
	cd /var/www/html/extensions/Widgets; \
	/usr/bin/php83 /usr/bin/composer.phar update; \
	cd /var/www/html; \
  # cldr
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/cldr /var/www/html/extensions/cldr; \
  # TemplateStyles
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles /var/www/html/extensions/TemplateStyles; \
  # TemplateStylesExtender
  git clone https://github.com/octfx/mediawiki-extensions-TemplateStylesExtender /var/www/html/extensions/TemplateStylesExtender; \
  # LabeledSectionTransclusion
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/LabeledSectionTransclusion /var/www/html/extensions/LabeledSectionTransclusion; \
  # Disambiguator
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/Disambiguator /var/www/html/extensions/Disambiguator; \ 
  # CodeMirror
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/CodeMirror /var/www/html/extensions/CodeMirror; \
  # VipsScaler
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/VipsScaler /var/www/html/extensions/VipsScaler; \
  # Cargo
  git clone https://github.com/wikimedia/mediawiki-extensions-Cargo /var/www/html/extensions/Cargo; \
  # VariablesLua
  git clone https://github.com/Liquipedia/VariablesLua /var/www/html/extensions/VariablesLua; \
  # SimpleMathJax
  git clone https://github.com/jmnote/SimpleMathJax /var/www/html/extensions/SimpleMathJax; \
  # AWS
  git clone https://github.com/edwardspec/mediawiki-aws-s3 /var/www/html/extensions/AWS; \
  # MultiPurge
  git clone https://github.com/octfx/mediawiki-extensions-MultiPurge /var/www/html/extensions/MultiPurge; \
  # TabberNeue
  git clone https://github.com/StarCitizenTools/mediawiki-extensions-TabberNeue.git /var/www/html/extensions/TabberNeue; \
  # Popups
  git clone --branch REL1_41 https://gerrit.wikimedia.org/r/mediawiki/extensions/Popups /var/www/html/extensions/Popups; \
  # skin
  git clone https://github.com/StarCitizenTools/mediawiki-skins-Citizen /var/www/html/skins/Citizen; \
  # fix permissions
  chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx /var/log/php83;

# composer
COPY config/composer.local.json /var/www/html/composer.local.json
RUN cd /var/www/html;/usr/bin/php83 /usr/bin/composer.phar update --no-dev;

USER nobody

# copy nginx.conf
COPY config/nginx.conf /etc/nginx/nginx.conf

# copy php-fpm configuration
COPY config/fpm-pool.conf /etc/php83/php-fpm.d/www.conf
COPY config/php.ini /etc/php83/conf.d/custom.ini
COPY config/luasandbox.ini /etc/php83/conf.d/luasandbox.ini
COPY config/opcache.ini /etc/php83/conf.d/opcache.ini

# copy supervisord.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy LocalSettings
COPY --chown=nobody:nobody config/LocalSettings.php /var/www/html/LocalSettings.php
COPY --chown=nobody:nobody config/LocalSettings_extensions.php /var/www/html/LocalSettings_extensions.php

# expose port 8080
EXPOSE 8080

# bring up supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]