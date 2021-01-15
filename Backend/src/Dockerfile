FROM php:7.2.7-fpm-alpine
COPY . /var/www/html
RUN apk update && apk add bash
WORKDIR /var/www/html
RUN docker-php-ext-install mysqli \
    && chown -Rf www-data:www-data /var/www/html

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /tmp/
RUN chmod -R 777 /var/www/html
RUN chmod +x /tmp/wait-for-it.sh
