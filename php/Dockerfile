ARG IMAGE_NAME
ARG PHP_VERSION
ARG PHP_VARIANT
FROM ${IMAGE_NAME}:${PHP_VERSION}-${PHP_VARIANT} as base

ARG MEMCACHED_VERSION
ARG REDIS_VERSION
ARG APCUBC_VERSION
ARG PHP_VARIANT

RUN env \
    && printf "\
    date.timezone=\"UTC\"\n\
    request_order=GP\n\
    expose_php=Off\n\
    enable_dl=Off\n\
    short_open_tag=Off\n\
    zend.assertions=-1\n\
    " > /usr/local/etc/php/php.ini \
    && docker-php-source extract \
    && apt-get update \
    && apt-get install -y cron supervisor \
    && apt-get install -y curl git-core \
    && apt-get install -y \
        zlib1g-dev \
        libicu-dev \
        libpq-dev \
        libxml2-dev \
        libc-client-dev \
        libmcrypt-dev \
        sudo \
    && docker-php-ext-install opcache \
    && printf "\
    opcache.max_accelerated_files=16229\n\
    opcache.enable_file_override=1\n\
    opcache.log_verbosity_level=0\n\
    opcache.fast_shutdown=1\n\
    " >> /usr/local/etc/php/conf.d/00-opcache.ini \
    && docker-php-ext-install \
        zip \
        intl \
        bcmath \
        mcrypt \
        pgsql \
        pdo_pgsql \
    && apt-get remove --purge -y \
        libicu-dev \
        icu-devtools \
        libpq-dev \
        libxml2-dev \
        libc-client-dev \
        libmcrypt-dev \
    && apt-get install -y \
        libicu52 \
        libc-client2007e \
        libpq5 \
        libmcrypt4 \
    && if [ -z "$MEMCACHED_VERSION" ] ; then \
        echo "Don't installing memcached extension"; \
    else \
        apt-get install -y libmemcached-dev \
        && pecl install memcached-${MEMCACHED_VERSION} \
        && docker-php-ext-enable --ini-name 100-memcached.ini memcached \
        && apt-get remove --purge -y libmemcached-dev zlib1g-dev \
        && apt-get install -y libmemcached11 libmemcachedutil2; \
    fi \
    && if [ -z "$REDIS_VERSION" ] ; then \
        echo "Don't installing redis extension"; \
    else \
        pecl install redis-${REDIS_VERSION} \
        && docker-php-ext-enable --ini-name 100-redis.ini redis; \
    fi \
    && if [ -z "$APCUBC_VERSION" ] ; then \
        echo "Don't installing apcu_bc extension"; \
    else \
        printf "\n" | pecl install apcu_bc-${APCUBC_VERSION} \
        && printf "\
        extension=apcu.so\n\
        extension=apc.so\n\
        " > $PHP_INI_DIR/conf.d/100-apc.ini; \
    fi \
    && docker-php-source delete \
    && apt-get remove --purge -y libx11-6 $PHPIZE_DEPS \
    && apt-get -y autoremove \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf \
        /tmp/* \
        /usr/share/doc \
        /usr/share/man \
        /usr/share/doc \
    && useradd -k /dev/null -m -u 1000 -U php \
    && usermod -aG sudo php \
    && echo "php ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates" >> /etc/sudoers \
    && mkdir -p /home/php/app /home/php/bin \
    && chown php:php /home/php/app /home/php/bin \
    && printf "display_errors=Off\nlog_errors=On\n" >> /usr/local/etc/php/php.ini \
    && if [ "apache" = "$PHP_VARIANT" ] ; then \
        a2enmod rewrite \
        && rm -rf /var/www/html \
        && mkdir -p /home/php/app/web \
        && chown php:php /home/php/app/web \
        && ln -sf /home/php/app/web/ /var/www/html \
        && sed -i -e 's/^ServerSignature.*/ServerSignature Off/' -e 's/^ServerTokens.*/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf \
        && touch /etc/apache2/conf-enabled/headers.conf \
        && printf "\
<IfModule mod_headers.c>\n\
\t<Directory />\n\
\t\tHeader always set X-XSS-Protection \"1; mode=block\"\n\
\t\tHeader always set x-Frame-Options \"SAMEORIGIN\"\n\
\t\tHeader always set X-Content-Type-Options \"nosniff\"\n\
\t\tHeader always set Pragma \"no-cache\"\n\
\t\tHeader always set Cache-Control \"no-store\"\n\
\t\tHeader always set Strict-Transport-Security \"max-age=31536000; includeSubDomains\"\n\
\t\tHeader always set Content-Security-Policy \"default-src 'self'; font-src *;img-src * data:; script-src *; style-src *;\"\n\
\t\tHeader always set Referrer-Policy \"strict-origin\"\n\
\t</Directory>\n\
</IfModule>\n\
" > /etc/apache2/conf-enabled/headers.conf; \
    fi

USER php
ENV PATH="$PATH:/home/php/bin" \
    COMPOSER_BIN_DIR=/home/php/bin

ARG COMPOSER_VERSION
RUN if [ -z "$COMPOSER_VERSION" ] ; then \
        echo "Not installing composer"; \
    else \
        curl -sL https://getcomposer.org/installer | php -- --install-dir=/home/php/bin --filename=composer --version=${COMPOSER_VERSION} \
        && chown php:php /home/php/bin/composer; \
    fi

ARG PRESTISSIMO_VERSION
RUN if [ -z "$PRESTISSIMO_VERSION" ] || [ "$PRESTISSIMO_VERSION$COMPOSER_VERSION" == "$PRESTISSIMO_VERSION" ] ; then \
        echo "Not installing prestissimo"; \
    else \
        composer global require hirak/prestissimo:$PRESTISSIMO_VERSION && composer global clear-cache -vvv; \
    fi

WORKDIR /home/php/app

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

FROM base as nodejs

USER root
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && apt-get -y autoremove \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /tmp/*
USER php

FROM base as tideways

USER root
RUN echo 'deb http://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages debian main' > /etc/apt/sources.list.d/tideways.list \
    && curl -sL https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg | apt-key add - \
    && apt-get update \
    && apt-get install tideways-php tideways-daemon \
    && apt-get -y autoremove \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /tmp/*
USER php

COPY entrypoint-tideways.sh /

ENTRYPOINT ["/entrypoint-tideways.sh"]

FROM nodejs as nodejs-tideways

USER root
RUN echo 'deb http://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages debian main' > /etc/apt/sources.list.d/tideways.list \
    && curl -sL https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg | apt-key add - \
    && apt-get update \
    && apt-get install tideways-php tideways-daemon \
    && apt-get -y autoremove \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /tmp/*
USER php

COPY entrypoint-tideways.sh /

ENTRYPOINT ["/entrypoint-tideways.sh"]
