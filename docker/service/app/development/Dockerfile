FROM mpdude/orchestration-app:base

ENV BUILD_DEPS="autoconf g++ make"
ENV COMPOSER_DEPS="git"

RUN apt-get update \
    && apt-get install -y ${BUILD_DEPS} ${COMPOSER_DEPS} \
    && apt-get remove -y ${BUILD_DEPS}

COPY --from=composer:1.7 /usr/bin/composer /usr/bin/composer
