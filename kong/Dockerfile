ARG IMAGE_NAME
ARG KONG_VERSION
ARG KONG_VARIANT
FROM ${IMAGE_NAME}:${KONG_VERSION}-${KONG_VARIANT}

COPY kong-entrypoint.sh /kong-entrypoint.sh
COPY wait-for.sh /wait-for.sh

ENTRYPOINT [ "/kong-entrypoint.sh" ]

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/usr/local/kong/nginx.conf", "-p", "/usr/local/kong/"]
