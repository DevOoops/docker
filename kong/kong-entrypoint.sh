#!/usr/bin/env sh

# if secret is set
if [ -f /run/secrets/kong_pg_password ]; then
    KONG_PG_PASSWORD=$(cat /run/secrets/kong_pg_password)

    echo "Kong pg password found"
fi

echo "continue to basic entrypoint with args $@"
exec /docker-entrypoint.sh $@
