#!/usr/bin/env sh

# if secret is set
if [ -f /run/secrets/newrelic_license ]; then
    NEWRELIC_LICENSE=$(cat /run/secrets/newrelic_license)
fi

# if env or secret is set
if [ ! -z "$NEWRELIC_LICENSE" ]; then
    NEWRELIC_APP_NAME="${XEONYS_APP_NAME:-docker}-${XEONYS_PLATFORM_ENV}-${XEONYS_PLATFORM}"
    
    printf "Newrelic appname '${NEWRELIC_APP_NAME}'\n"
    
    # Configure newrelic with env vars
    printf "\
    extension=newrelic.so \n\
    newrelic.license=${NEWRELIC_LICENSE} \n\
    newrelic.appname=${NEWRELIC_APP_NAME}\n\
    " > /usr/local/etc/php/conf.d/newrelic.ini
fi

# Proceed with normal container startup
exec apache2-foreground
