#!/usr/bin/env sh
set -e

# setting max upload size
if [ ! -z "$UPLOAD_MAX_SIZE" ]; then
    printf "\
    upload_max_filesize=${UPLOAD_MAX_SIZE} \n\
    post_max_size=${UPLOAD_MAX_SIZE} \n\
    " | sudo tee /usr/local/etc/php/conf.d/uploads.ini > /dev/null

    echo "Setting upload_max_filesize & post_max_size to $UPLOAD_MAX_SIZE"
fi

if [ ! -z "$K8S_CONTEXT" -a "$(id -g)" = "0" ]; then
    groups=$(id -G | sed -e 's/^0//')
    if [ ! -z "$groups" ]; then
        for gid in $groups ; do
            groupadd $gid -g $gid
        done
        usermod -a -G $(echo $groups | sed -e 's/ /,/g' -e 's/^,//') php
    fi
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
    exec apache2-foreground
else
    echo "Starting $@"
    exec $@
fi
