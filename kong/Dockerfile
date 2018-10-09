ARG IMAGE_NAME
ARG KONG_VERSION
FROM ${IMAGE_NAME}:${KONG_VERSION}-alpine

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

COPY run.sh /

ENTRYPOINT [ "/run.sh" ]

# need to be redefined...
CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/usr/local/kong/nginx.conf", "-p", "/usr/local/kong/"]