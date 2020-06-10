FROM httpd:2.4.33-alpine
RUN apk update
COPY my.apache.conf /usr/local/apache2/conf/my.apache.conf
COPY .htaccess /var/www/html/.htaccess
RUN echo "Include /usr/local/apache2/conf/my.apache.conf" \
    >> /usr/local/apache2/conf/httpd.conf
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN sed -i '/LoadModule headers_module/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN { \
  echo 'IncludeOptional conf.d/*.conf'; \
} >> /usr/local/apache2/conf/httpd.conf \
  && mkdir /usr/local/apache2/conf.d
