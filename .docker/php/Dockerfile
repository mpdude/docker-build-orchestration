ARG BASEIMAGE=php:8.0
FROM ${BASEIMAGE} as php_base

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions opcache

####

ARG COMPOSER_VERSION=latest
FROM php_base as php_composer

RUN apt-get update && apt-get install -qy zip git ssh-client
COPY --from=composer /usr/bin/composer /usr/bin/composer

VOLUME /composer-cache

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV SSH_AUTH_SOCK /tmp/auth.sock
ENV COMPOSER_CACHE_DIR /composer-cache

ENTRYPOINT ["/usr/bin/composer"]
# CMD ["install"]
