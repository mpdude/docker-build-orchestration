FROM php:8.3-apache AS php_runtime
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions mysqli pdo_mysql opcache gettext zip intl

FROM php_runtime AS php_development
RUN install-php-extensions xdebug
COPY 20-xdebug.ini /usr/local/etc/php/conf.d

FROM php_runtime AS php_composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN apt-get update && apt-get install -y git ssh-client zip
ENV COMPOSER_CACHE_DIR=/composer-cache COMPOSER_HOME=/composer-home SSH_AUTH_SOCK=/tmp/auth.sock
ENTRYPOINT ["/usr/bin/composer"]
