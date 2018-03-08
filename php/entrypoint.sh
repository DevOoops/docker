#!/usr/bin/env sh

# setting max upload size
if [ ! -z "$UPLOAD_MAX_SIZE" ]; then
    printf "\
    upload_max_filesize=${UPLOAD_MAX_SIZE} \n\
    post_max_size=${UPLOAD_MAX_SIZE} \n\
    " > /usr/local/etc/php/conf.d/uploads.ini
fi

# dont show php errors on prod env
if [ "$SYMFONY_ENV" = "prod" ]; then
    printf "\
    error_reporting=0 \n\
    " > /usr/local/etc/php/conf.d/prod.ini
fi
# Proceed with normal container startup
exec apache2-foreground
