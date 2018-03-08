#!/usr/bin/env bash

# try to get rancher container name
TIDEWAY_HOST=${TIDEWAY_HOST:-$(curl -s rancher-metadata/latest/self/container/name)}
if [ "$TIDEWAY_HOST" = "" ]; then
    TIDEWAY_HOST=$(cat /etc/hostname)
fi

echo "starting tideways proxy with host $TIDEWAY_HOST"
/usr/bin/tideways-proxy --listen=0.0.0.0:8137 --hostname=$TIDEWAY_HOST
