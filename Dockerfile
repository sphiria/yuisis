FROM alpine:3.19.1
ENV MEDIAWIKI_MAJOR_VERSION=1.42
ENV MEDIAWIKI_VERSION=1.42.3
ENV MEDIAWIKI_BRANCH=REL1_42
ENV COMPOSER_ALLOW_SUPERUSER=1
LABEL Maintainer="lis <hello@lis.sh>"
LABEL Description="Lightweight Mediawiki 1.42.3 container with Nginx 1.26 & PHP 8.3 based on Alpine Linux 3.20"
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
  php83 \
  php83-fpm \
  php83-curl \
  php83-ctype \
  php83-gd \
  php83-intl \
  php83-json \
  php83-iconv \
  php83-calendar \
  php83-exif \
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
  php83-posix \
  php83-pcntl \
  php83-pecl-redis \
  php83-pecl-luasandbox \
  # mediawiki dependencies
  imagemagick \
  python3 \
  diffutils \
  vips-tools \ 
  composer \
  # supervisor
  supervisor; \
  # download mediawiki
  curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz; \
	tar -x --strip-components=1 -f mediawiki.tar.gz; \
	# clean-up
	rm -rf mediawiki.tar.gz UPGRADE SECURITY RELEASE-NOTES-${MEDIAWIKI_MAJOR_VERSION} README.md INSTALL HISTORY FAQ CREDITS COPYING CODE_OF_CONDUCT.md; \
  # install extensions
  # Flow
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Flow /var/www/html/extensions/Flow; \
	cd /var/www/html/extensions/Flow; \
	/usr/bin/php83 /usr/bin/composer.phar update --no-dev; \
	cd /var/www/html; \
  # Arrays
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Arrays /var/www/html/extensions/Arrays; \
  # DynamicPageList3
  git clone https://github.com/Universal-Omega/DynamicPageList3 /var/www/html/extensions/DynamicPageList3; \
  cd /var/www/html/extensions/DynamicPageList3;git checkout 955be3f; \
  # EmbedVideo (fork)
  git clone https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo /var/www/html/extensions/EmbedVideo; \
  cd /var/www/html/extensions/EmbedVideo;git checkout 3d81247; \
  # MsUpload
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/MsUpload /var/www/html/extensions/MsUpload; \
  # Variables
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Variables /var/www/html/extensions/Variables; \
  # Loops
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Loops /var/www/html/extensions/Loops; \
  # RegexFunctions
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/RegexFunctions /var/www/html/extensions/RegexFunctions; \
  # TemplateSandbox
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateSandbox /var/www/html/extensions/TemplateSandbox; \
  # ShortDescription
  git clone https://github.com/StarCitizenTools/mediawiki-extensions-ShortDescription /var/www/html/extensions/ShortDescription; \
  cd /var/www/html/extensions/ShortDescription;git checkout 0fa533d; \
  # WikiSEO
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/WikiSEO /var/www/html/extensions/WikiSEO; \
  # CheckUser
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser /var/www/html/extensions/CheckUser; \
	cd /var/www/html/extensions/CheckUser; \
	/usr/bin/php83 /usr/bin/composer.phar update --no-dev; \
	cd /var/www/html; \
  # AWS
  git clone https://github.com/edwardspec/mediawiki-aws-s3 /var/www/html/extensions/AWS; \
  cd /var/www/html/extensions/AWS;git checkout 28365ea; \
  # RegexFunctions
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/RegexFunctions /var/www/html/extensions/RegexFunctions; \
  # RandomSelection
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/RandomSelection /var/www/html/extensions/RandomSelection; \
  # Widgets
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets /var/www/html/extensions/Widgets; \
	cd /var/www/html/extensions/Widgets; \
	/usr/bin/php83 /usr/bin/composer.phar update --no-dev; \
	cd /var/www/html; \
  # cldr
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/cldr /var/www/html/extensions/cldr; \
  # Elastica
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Elastica /var/www/html/extensions/Elastica; \
  cd /var/www/html/extensions/Elastica; \
	/usr/bin/php83 /usr/bin/composer.phar install --no-dev; \
	cd /var/www/html; \
  # CirrusSearch
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/CirrusSearch /var/www/html/extensions/CirrusSearch; \
  cd /var/www/html/extensions/CirrusSearch; \
	/usr/bin/php83 /usr/bin/composer.phar install --no-dev; \
	cd /var/www/html; \
  # DeletePagesForGood
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/DeletePagesForGood /var/www/html/extensions/DeletePagesForGood; \
  # Discord
  git clone --single-branch https://github.com/jayktaylor/mw-discord /var/www/html/extensions/Discord; \
  cd /var/www/html/extensions/Discord;git checkout 094c994; \
  # ImportArticles
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/ImportArticles /var/www/html/extensions/ImportArticles; \
  # OAuth
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/OAuth /var/www/html/extensions/OAuth; \
  # TemplateStyles
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles /var/www/html/extensions/TemplateStyles; \
  # TemplateStylesExtender
  git clone https://github.com/octfx/mediawiki-extensions-TemplateStylesExtender /var/www/html/extensions/TemplateStylesExtender; \
  cd /var/www/html/extensions/TemplateStylesExtender;git checkout 5b97d8f; \
  # LabeledSectionTransclusion
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/LabeledSectionTransclusion /var/www/html/extensions/LabeledSectionTransclusion; \
  # DarkMode
  git clone --single-branch https://github.com/sphiria/mediawiki-extensions-DarkMode /var/www/html/extensions/DarkMode; \ 
  # Disambiguator
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Disambiguator /var/www/html/extensions/Disambiguator; \ 
  # CodeMirror
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/CodeMirror /var/www/html/extensions/CodeMirror; \
  # VipsScaler
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/VipsScaler /var/www/html/extensions/VipsScaler; \
  # Cargo
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Cargo /var/www/html/extensions/Cargo; \
  # VariablesLua
  git clone https://github.com/Liquipedia/VariablesLua /var/www/html/extensions/VariablesLua; \
  cd /var/www/html/extensions/VariablesLua;git checkout 64a5776; \
  # SimpleMathJax
  git clone https://github.com/jmnote/SimpleMathJax /var/www/html/extensions/SimpleMathJax; \
  cd /var/www/html/extensions/SimpleMathJax;git checkout fab35e6; \
  # MultiPurge
  git clone --branch develop https://github.com/octfx/mediawiki-extensions-MultiPurge /var/www/html/extensions/MultiPurge; \
  cd /var/www/html/extensions/MultiPurge;git checkout be6b569; \
  # TabberNeue
  git clone https://github.com/StarCitizenTools/mediawiki-extensions-TabberNeue /var/www/html/extensions/TabberNeue; \
  cd /var/www/html/extensions/TabberNeue; \
  git checkout 268010c0b1e5c53c65c36a22430b49909d570d17; \
  # Popups
  git clone --branch ${MEDIAWIKI_BRANCH} --single-branch https://gerrit.wikimedia.org/r/mediawiki/extensions/Popups /var/www/html/extensions/Popups; \
  # fix permissions
  chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx /var/log/php83;

# composer
COPY config/composer.local.json /var/www/html/composer.local.json
RUN cd /var/www/html;/usr/bin/php83 /usr/bin/composer.phar update --no-dev;

USER nobody

# copy jobrunner
COPY config/jobrunner /var/www/jobrunner

# copy searchrunner
COPY config/searchrunner /var/www/searchrunner

# copy nginx.conf
COPY config/nginx.conf /etc/nginx/nginx.conf

# copy php configurations
COPY config/php/fpm-pool.conf /etc/php83/php-fpm.d/www.conf
COPY config/php/php.ini /etc/php83/conf.d/custom.ini
COPY config/php/luasandbox.ini /etc/php83/conf.d/luasandbox.ini
COPY config/php/opcache.ini /etc/php83/conf.d/opcache.ini

# copy supervisord.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy resources
COPY resource/robots.txt /var/www/html/robots.txt
COPY resource/favicon.ico /var/www/html/favicon.ico

# expose port 8080
EXPOSE 8080

# bring up supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]