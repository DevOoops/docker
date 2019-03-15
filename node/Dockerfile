ARG NODE_VERSION
FROM node:${NODE_VERSION}

ARG WATCHMAN_VERSION

RUN apt-get update \
    && apt-get install -y build-essential python-dev automake autoconf \
    && cd /tmp \
    && git clone https://github.com/facebook/watchman.git \
    && cd watchman \
    && git checkout ${WATCHMAN_VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make -j $(nproc --all) \
    && make install \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf /tmp/* \
    && echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf \
    && echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf \
    && echo fs.inotify.max_queued_events=524288 | sudo tee -a /etc/sysctl.conf \
    && sudo sysctl -p
