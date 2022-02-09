FROM php:7.4-apache AS magento2-php74-apache

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "zsh"]

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	software-properties-common \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libfreetype6-dev \
    libonig-dev \
	libicu-dev \
	libzip-dev \
    libssl-dev \
	libjpeg62-turbo-dev \
	libedit-dev \
	libedit2 \
	libxslt1-dev \
	apt-utils \
	gnupg \
	redis-tools \
	git \
	vim \
	wget \
	curl \
	lynx \
	psmisc \
	unzip \
	tar \
	cron \
	bash-completion

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN docker-php-ext-configure \
  	gd --with-freetype --with-jpeg; \
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
    mysqli \
  	zip

RUN apt-get update \
  	&& apt-get install -y \
  	libpcre3 \
  	libpcre3-dev \
  	&& pecl install oauth \
  	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini \
  	&& echo "extension=bcmath.so" > /usr/local/etc/php/conf.d/docker-php-ext-bcmath.ini

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

ADD /docker/config/magento.conf /etc/apache2/sites-available/magento.conf
ADD /docker/config/php.ini /usr/local/etc/php/php.ini
ADD /docker/config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf

RUN a2enmod rewrite

VOLUME /var/www/htdocs/html
WORKDIR /var/www/htdocs/html
