#Dockerfile to be used in CI-CD

FROM php:7.4.0-apache
WORKDIR /var/www/html
RUN apt-get update
RUN apt-get -yq install libapache2-mod-security2 unzip zlib1g-dev libicu-dev libxml2-dev libxslt1-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev libxpm-dev
RUN cd /usr/local/etc/php/conf.d/ && echo 'memory_limit = 3G\ndate.timezone = Asia/Kolkata\nrealpath_cache_size = 10M\nrealpath_cache_ttl = 7200\nopcache.save_comments = 1' >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN a2enmod rewrite deflate headers ssl security2 proxy_http
RUN service apache2 restart
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install bcmath intl pdo_mysql soap xsl zip sockets gd opcache
RUN curl https://getcomposer.org/composer-1.phar --output composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer 
RUN composer config --global http-basic.repo.magento.com a573db60505acdbec40720f28ea8acf5 ed65e9863a0470c0ef181d180ed533c5 \
    && composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition magento2 
RUN cd magento2 && find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
RUN cd magento2 && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
RUN cd magento2 && chown -R :www-data .
RUN cd magento2 && chmod u+x bin/magento