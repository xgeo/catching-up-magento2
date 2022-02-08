FROM php:7.4-cli

WORKDIR /app

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	software-properties-common \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libonig-dev \
	libfreetype6-dev \
	libicu-dev \
  libssl-dev \
	libjpeg62-turbo-dev \
	libedit-dev \
    libzip-dev \
	libedit2 \
	libxslt1-dev \
	apt-utils \
	gnupg \
	git \
	nano \
	wget \
	curl \
     curl \
    zip \
    unzip \
	lynx \
	psmisc \
	unzip \
	tar \
	cron \
	bash-completion \
	&& apt-get clean

RUN docker-php-ext-configure \
  	gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  	docker-php-ext-install \
  	opcache \
  	gd \
  	bcmath \
  	intl \
    sockets \
  	mbstring \
  	pdo_mysql \
  	soap \
  	xsl \
  	zip

RUN apt-get update \
  	&& apt-get install -y \
  	libpcre3 \
  	libpcre3-dev \
  	&& pecl install oauth \
  	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini \
  	&& echo "extension=bcmath.so" > /usr/local/etc/php/conf.d/docker-php-ext-bcmath.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

COPY .. .