FROM php:7.3.12-apache-stretch

RUN apt-get autoclean

RUN apt-get update

# 1. development packages
RUN apt-get install -y \
    apt-utils \
    build-essential \
    debconf-utils \
    debconf \
    locales \
	iproute2 \
    git \
    zip \
    wget \
    gnupg \
    unzip \
    nano \
    libxml2-dev \
    libldb-dev \
    libldap2-dev \
    libpq-dev \
    libzip-dev \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    openssh-client \
    libmcrypt-dev \
    libreadline-dev \
    zlib1g-dev \
    libfreetype6-dev \
	cron \
	supervisor

RUN \
  echo "deb http://ftp.au.debian.org/debian/ stretch main non-free contrib" > /etc/apt/sources.list && \
  echo "deb-src http://ftp.au.debian.org/debian/ stretch main non-free contrib" >> /etc/apt/sources.list && \
  echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
  echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
  apt-get -qq update && apt-get -qqy upgrade && apt-get -q autoclean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*

# 3. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# 4. start with base php config, then add extensions
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-install \
    bcmath \
    bz2 \
    dom \
    gd \
    json \
    ldap \
    mbstring \
    pgsql \
    mysqli \
    intl \
    iconv \
    opcache \
    calendar \
    pdo_mysql \
    pdo_pgsql \
    xml



RUN docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install zip

#add unsupported php files via pecl
RUN pecl install mcrypt && docker-php-ext-enable mcrypt && \
	pecl config-set php_ini /etc/php/7.3/apache2/php.ini

# 6. Configure needed apache modules and disable default site
RUN a2dismod   mpm_event  cgi # mpm_worker enabled.
RUN a2enmod		\
  access_compat		\
  actions		\
  alias			\
  auth_basic		\
  authn_core		\
  authn_file		\
  authz_core		\
  authz_groupfile	\
  authz_host 		\
  authz_user		\
  autoindex		\
  dir			\
  env 			\
  expires 		\
  filter 		\
  headers		\
  mime 			\
  negotiation 		\
  mpm_prefork 		\
  reqtimeout 		\
  rewrite 		\
  setenvif 		\
  status 		\
  ssl

# 7. composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 8. Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN node -v
RUN npm -v

#9. custom files
COPY ./docker_configs/custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY ./docker_configs/laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf

#10. Apache config
COPY ./docker_configs/000-default.conf /etc/apache2/sites-available/000-default.conf

#11. set script with entrypoint
COPY project_setup.sh /usr/local/bin/dockerInit

RUN chmod +x /usr/local/bin/dockerInit

ENTRYPOINT service apache2 start \
  && service supervisor start \
  && service cron start \
  && dockerInit \
  && /bin/bash
