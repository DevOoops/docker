#!/bin/sh
set -e

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

# Setting default prefix (override any existing variable)
export KONG_PREFIX="/usr/local/kong"

if [ -f /run/secrets/kong_pg_password ]; then
    export KONG_PG_PASSWORD=$(cat /run/secrets/kong_pg_password)

    echo "Kong pg password found"
fi

/wait-for.sh "$KONG_PG_HOST:5432"

# Prepare Kong prefix
if [ "$1" = "/usr/local/openresty/nginx/sbin/nginx" ]; then
	kong prepare -p "/usr/local/kong"
fi

exec "$@"
