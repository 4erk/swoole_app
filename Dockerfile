FROM php:8.3.13-zts
LABEL authors="4erk"


ARG ENV=PRODUCTION
ENV ENV=${ENV}

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-color

ARG DEV_MODE
ENV DEV_MODE=$DEV_MODE

COPY --from=composer:2.8.2 /usr/bin/composer /usr/bin/

COPY ./docker/ /

RUN \
    set -ex && \
    apt-get update  && \
    apt-get install -y \
        libcurl4-openssl-dev       \
        libbrotli-dev              \
        libpq-dev                  \
        libssl-dev                 \
        supervisor                 \
        unzip                      \
        zlib1g-dev                 \
        --no-install-recommends && \
# PHP extension pdo_mysql is included since 4.8.12+ and 5.0.1+.
    docker-php-ext-install pdo_mysql && \
    pecl channel-update pecl.php.net && \
    pecl install --configureoptions 'enable-redis-igbinary="no" enable-redis-lzf="no" enable-redis-zstd="no"' redis-6.1.0 && \
    docker-php-ext-enable redis && \
    install-swoole.sh 6.0.0-beta \
        --enable-mysqlnd      \
        --enable-swoole-pgsql \
        --enable-brotli       \
        --enable-openssl      \
        --enable-sockets      \
        --enable-swoole-curl  \
        --enable-swoole-thread  && \
    mkdir -p /var/log/supervisor && \
    rm -rf /var/lib/apt/lists/* /usr/bin/qemu-*-static



RUN set -ex && \
    pecl channel-update pecl.php.net && \
    if [ "$ENV" = "DEVELOP" ]; then \
        pecl install xdebug-stable; \
    fi


ENTRYPOINT ["/entrypoint.sh"]
CMD []

WORKDIR "/var/www/"