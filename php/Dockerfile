ARG IMAGE_NAME
ARG PHP_VERSION
ARG PHP_VARIANT
FROM ${IMAGE_NAME}:${PHP_VERSION}-${PHP_VARIANT}

ARG MEMCACHED_VERSION
ARG REDIS_VERSION
ARG APCUBC_VERSION

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
    && apt-get install -y jq curl git-core \
    && apt-get install -y \
        zlib1g-dev \
        libicu-dev \
        libpq-dev \
        libxml2-dev \
        libc-client-dev \
        libmcrypt-dev \
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
    && apt-get remove -y \
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
        && apt-get remove -y libmemcached-dev zlib1g-dev \
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
    && apt-get remove -y libx11-6 $PHPIZE_DEPS \
    && apt-get -y autoremove \
    && apt-get clean -y \
    && rm -rf \
        /tmp/* \
        /usr/share/doc \
        /usr/share/man \
        /usr/share/doc \
    && useradd -k /dev/null -m -u 1000 -U php \
    && mkdir -p /home/php/app /home/php/bin \
    && chown php:php /home/php/app /home/php/bin \
    && if [ "apache" = "$PHP_VARIANT" ] ; then \
        rm -rf /var/www/html \
        && ln -sf /home/php/app/web /var/www/html \
        && a2enmode rewrite; \
    fi

USER php
ENV PATH="$PATH:/home/php/bin" \
    COMPOSER_BIN_DIR=/home/php/bin

ARG COMPOSER_VERSION
RUN if [ -z "$COMPOSER_VERSION" ] ; then \
        echo "Don't installing composer"; \
    else \
        curl -sL https://getcomposer.org/installer | php -- --install-dir=/home/php/bin --filename=composer --version=${COMPOSER_VERSION} \
        && chown php:php /home/php/bin/composer; \
    fi

ARG PRESTISSIMO_VERSION
RUN if [ -z "$PRESTISSIMO_VERSION" ] || [ "$PRESTISSIMO_VERSION$COMPOSER_VERSION" == "$PRESTISSIMO_VERSION" ] ; then \
        echo "Don't installing prestissimo"; \
    else \
        composer global require hirak/prestissimo:$PRESTISSIMO_VERSION && composer global clear-cache -vvv; \
    fi

WORKDIR /home/php/app
