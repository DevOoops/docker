#!/usr/bin/env sh


# if secret is set
if [ -f /run/secrets/tideways_api_key ]; then
    TIDEWAYS_API_KEY=$(cat /run/secrets/tideways_api_key)

    echo "Tideways secret found"
fi

# if env or secret is set
if [ ! -z "$TIDEWAYS_API_KEY" ]; then

    TIDEWAYS_ENV="${TIDEWAYS_ENV:-${XEONYS_PLATFORM_ENV}}"
    if [ "$TIDEWAYS_ENV" = "prod" ]; then
        TIDEWAYS_ENV="production"
    fi
    echo "Tideways ENV $TIDEWAYS_ENV"

    # try to get rancher container name
    TIDEWAYS_HOST=${TIDEWAY_HOST:-$(curl -s rancher-metadata/latest/self/container/name)}
    if [ "$TIDEWAY_HOST" = "" ]; then
        TIDEWAYS_HOST=$(cat /etc/hostname)
    fi

    echo "Tideways HOST $TIDEWAYS_HOST"

    TIDEWAYS_APP_NAME=${TIDEWAYS_APP_NAME:-$(curl -s rancher-metadata/latest/self/stack/name)}

    echo "Tideways APP_NAME $TIDEWAYS_APP_NAME"

    # Configure tideway daemon with env vars
    printf "\
    TIDEWAYS_DAEMON_EXTRA=\"--hostname=${TIDEWAYS_HOST} --env=${TIDEWAYS_ENV} --server=${TIDEWAYS_PROXY} --insecure\" \n\
    " > /etc/default/tideways-daemon

    # Configure tideway agent with env vars
    printf "\
    extension=tideways.so \n\
    tideways.api_key=${TIDEWAYS_API_KEY} \n\
    tideways.service=${TIDEWAYS_APP_NAME} \n\
    tideways.framework=symfony2 \n\
    tideways.sample_rate=25 \n\
    tideways.monitor_cli=1 \n\
    " > /usr/local/etc/php/conf.d/tideways.ini

    # start daemon
    /etc/init.d/tideways-daemon start

fi
echo "continue to basic entrypoint with args $@"
exec /entrypoint.sh $@
