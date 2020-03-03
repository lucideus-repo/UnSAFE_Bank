FROM php:7.2.7-fpm-alpine
RUN apk update && apk add bash
RUN docker-php-ext-install mysqli

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /tmp/
RUN chmod +x /tmp/wait-for-it.sh