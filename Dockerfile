FROM phpswoole/swoole:6.0-php8.3
LABEL authors="4erk"

ARG ENV=PRODUCTION

ENV ENV=${ENV}

COPY ./docker/ /

RUN set -ex && \
    pecl channel-update pecl.php.net && \
    if [ "$ENV" = "DEVELOP" ]; then \
        pecl install xdebug-stable; \
    fi

ENTRYPOINT ["/entrypoint.sh"]
CMD []
