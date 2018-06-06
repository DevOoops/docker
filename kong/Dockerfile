FROM kong:0.13.1-alpine

COPY kong-entrypoint.sh /kong-entrypoint.sh

ENTRYPOINT [ "/kong-entrypoint.sh" ]

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/usr/local/kong/nginx.conf", "-p", "/usr/local/kong/"]
