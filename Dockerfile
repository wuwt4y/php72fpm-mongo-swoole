FROM alpine:3.9.3

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/phpearth/docker-php.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="PHP.earth" \
      org.label-schema.name="docker-php" \
      org.label-schema.description="Docker For PHP Developers - Docker image with PHP CLI 7.2, additional PHP extensions, and Alpine" \
      org.label-schema.url="https://github.com/phpearth/docker-php"

ENV \
    # When using Composer, disable the warning about running commands as root/super user
    COMPOSER_ALLOW_SUPERUSER=1 \
    # Persistent runtime dependencies
    DEPS="php7.2 \
        php7.2-phar \
        php7.2-bcmath \
        php7.2-calendar \
        php7.2-mbstring \
        php7.2-exif \
        php7.2-ftp \
        php7.2-openssl \
        php7.2-zip \
        php7.2-gd \
        php7.2-sysvsem \
        php7.2-sysvshm \
        php7.2-sysvmsg \
        php7.2-shmop \
        php7.2-sockets \
        php7.2-zlib \
        php7.2-bz2 \
        php7.2-curl \
        php7.2-simplexml \
        php7.2-xml \
        php7.2-opcache \
        php7.2-dom \
        php7.2-xmlreader \
        php7.2-xmlwriter \
        php7.2-tokenizer \
        php7.2-ctype \
        php7.2-session \
        php7.2-fileinfo \
        php7.2-iconv \
        php7.2-json \
        php7.2-mysqli \
        php7.2-pdo \
        php7.2-pdo_mysql \
        php7.2-pdo_sqlite \
        php7.2-posix \
        php7.2-dev \
        php7.2-pear \
        php7.2-fpm \
        php7.2-pcntl \
        curl \
        ca-certificates"


# PHP.earth Alpine repository for better developer experience
ADD https://repos.php.earth/alpine/phpearth.rsa.pub /etc/apk/keys/phpearth.rsa.pub

RUN apk --update add \
    bash \
    alpine-sdk \
    openssl-dev

RUN set -x \
    && echo "https://repos.php.earth/alpine/v3.9" >> /etc/apk/repositories \
    && apk add --no-cache $DEPS \
    && pecl install mongodb \
    && echo "extension=mongodb" >> /etc/php/7.2/php.ini \
    && apk add --update nodejs nodejs-npm \
    && rm -rf /var/cache/apk/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN composer self-update \
    && npm install -g npm

## 以下 是 swoole
RUN printf "no\n" | pecl install swoole \
   && pecl clear-cache \
   && echo "extension=swoole" >> /etc/php/7.2/php.ini


CMD ["/bin/bash"]
