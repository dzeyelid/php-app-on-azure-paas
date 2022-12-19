FROM php:8.1-fpm

COPY ./app /var/www/html

WORKDIR /var/www/html

RUN php artisan key:generate && \
  sed -i -E 's/^(APP_DEBUG)=.*$/\1=false/g' .env

RUN chown -R www-data:www-data ./storage \
  && chmod -R ug+w ./storage