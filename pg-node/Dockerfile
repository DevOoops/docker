ARG PG_VERSION
FROM postgres:${PG_VERSION}

ARG NODE_VERSION

RUN apt-get update \
    && apt-get install -y wget \
    && cd /tmp \
    && wget -q https://nodejs.org/dist/latest-v8.x/node-v${NODE_VERSION}-linux-x64.tar.gz \
    && tar xzf node-v8.16.0-linux-x64.tar.gz --strip-components=1 -C /usr/local \
    && rm node-v8.16.0-linux-x64.tar.gz \
    && npm i -g yarn \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /tmp/*

COPY pg-node-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["pg-node-entrypoint.sh"]