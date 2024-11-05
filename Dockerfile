FROM phpswoole/swoole:6.0-php8.3
LABEL authors="4erk"

ARG ENV=prod
ARG DEBUG=false

ENV ENV=${ENV}
ENV DEBUG=${DEBUG}

COPY ./docker/ /

RUN \
    set -ex && \
    pecl channel-update pecl.php.net && \
    pecl install xdebug-stable

ENTRYPOINT ["/entrypoint.sh"]
CMD []
