#!/usr/bin/env sh

# setting max upload size
if [ ! -z "$UPLOAD_MAX_SIZE" ]; then
    printf "\
    upload_max_filesize=${UPLOAD_MAX_SIZE} \n\
    post_max_size=${UPLOAD_MAX_SIZE} \n\
    " > /usr/local/etc/php/conf.d/uploads.ini

    echo "Setting upload_max_filesize & post_max_size to $UPLOAD_MAX_SIZE"
fi

# dont show php errors on prod env
if [ "$SYMFONY_ENV" = "prod" ]; then
    printf "\
    error_reporting=0 \n\
    " > /usr/local/etc/php/conf.d/prod.ini

    echo "Setting error_reporting to 0 due of prod env"
fi

# Proceed with normal container startup
if [ $# -eq 0 ]; then
    exec apache2-foreground
else
    echo "Starting $@"
    exec $@
fi

