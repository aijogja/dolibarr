FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y git libpng-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
        && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
        && docker-php-ext-install gd

RUN docker-php-ext-install mysqli

ENV DOLIBARR_VERSION 3.5.0

RUN curl -o dolibarr.tar.gz -SL https://github.com/Dolibarr/dolibarr/archive/${DOLIBARR_VERSION}.tar.gz \
        && tar -xzf dolibarr.tar.gz -C /usr/src/ \
        && rm dolibarr.tar.gz \
    && mv /usr/src/dolibarr-${DOLIBARR_VERSION} /var/www/html/dolibarr


RUN mkdir /var/www/html/dolibarr/documents
RUN chown -hR www-data:www-data /var/www/html


COPY inpo.php /var/www/html/
COPY config/php.ini /usr/local/etc/php/
COPY sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
