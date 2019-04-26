#!/usr/bin/env bash
set -Eeo pipefail

docker-entrypoint.sh postgres &

until psql -U postgres -c '\l' &> /dev/null ; do
	echo -n
done

exec "$@"