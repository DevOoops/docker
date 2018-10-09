#!/usr/bin/env sh

if [ "$(ls -A /usr/local/share/ca-certificates)" ]; then
  # normally we'd use update-ca-certificates, but something about running it in
  # Alpine is off, and the certs don't get added. Fortunately, we only need to
  # add ca-certificates to the global store and it's all plain text.
  cat /usr/local/share/ca-certificates/* >> /etc/ssl/certs/ca-certificates.crt
fi

echo "continue to kong entrypoint with args $@"
exec /docker-entrypoint.sh "$@"