FROM php:5.6-apache
WORKDIR /var/www/html
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN a2enmod rewrite
RUN docker-php-ext-install mysqli
RUN apt-get update
RUN apt-get install -y openssl libssl-dev libcurl4-openssl-dev
RUN pecl install mongo && echo "extension=mongo.so" > /usr/local/etc/php/conf.d/mongo.ini
COPY . .
RUN chmod 777 /mnt