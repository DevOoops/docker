#!/usr/bin/env sh
set -e

if [ ! -z "$K8S_CONTEXT" -a "$(id -g)" = "0" ]; then
    groups=$(id -G | sed -e 's/^0//')
    if [ ! -z "$groups" ]; then
        for gid in $groups ; do
            groupadd $gid -g $gid
        done
        usermod -a -G $(echo $groups | sed -e 's/ /,/g' -e 's/^,//') php
    fi
fi

# setting redis session handler
if { [ ! -z "$REDIS_HOST" ] && [ ! -z "$APP_NAME" ];}; then
    printf "\
    session.save_handler = redis \n\
    session.save_path = \"tcp://${REDIS_HOST}:6379?weight=1&prefix=${XEONYS_PLATFORM_ENV}-${XEONYS_PLATFORM}-${APP_NAME}:session:\" \n\
    " | sudo tee /usr/local/etc/php/conf.d/sessions.ini > /dev/null

    echo "Setting redis session on $REDIS_HOST server"
fi

# setting max upload size
if [ ! -z "$UPLOAD_MAX_SIZE" ]; then
    printf "\
    upload_max_filesize=${UPLOAD_MAX_SIZE} \n\
    post_max_size=${UPLOAD_MAX_SIZE} \n\
    " | sudo tee /usr/local/etc/php/conf.d/uploads.ini > /dev/null

    echo "Setting upload_max_filesize & post_max_size to $UPLOAD_MAX_SIZE"
fi

# setting max execution time
if [ ! -z "$MAX_EXECUTION_TIME" ]; then
    printf "\
    max_execution_time=${MAX_EXECUTION_TIME} \n\
    " | sudo tee /usr/local/etc/php/conf.d/execution_time.ini > /dev/null

    echo "Setting max_execution_time to $MAX_EXECUTION_TIME"
fi

# setting memory_limit
if [ ! -z "$MEMORY_LIMIT" ]; then
    printf "\
    memory_limit=${MEMORY_LIMIT} \n\
    " | sudo tee /usr/local/etc/php/conf.d/memory.ini > /dev/null

    echo "Setting memory_limit to $MEMORY_LIMIT"
fi

# dont show php errors on prod env
if [ "$SYMFONY_ENV" = "prod" ]; then
    printf "\
    error_reporting=0 \n\
    " | sudo tee /usr/local/etc/php/conf.d/prod.ini > /dev/null

    echo "Setting error_reporting to 0 due of prod env"
fi

# Update CA Certificates (update /etc/ssl/certs and certificates.crt)
sudo update-ca-certificates

# Proceed with normal container startup
if [ $# -eq 0 ]; then
    gosu php console cache:warmup
    exec apache2-foreground
else
    echo "Starting $@"
    exec "$@"
fi
