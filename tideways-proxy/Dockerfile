FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install curl coreutils -y

RUN echo 'deb http://s3-eu-west-1.amazonaws.com/tideways/packages debian main' > /etc/apt/sources.list.d/tideways.list \
    && curl -sS 'https://s3-eu-west-1.amazonaws.com/tideways/packages/EEB5E8F4.gpg' | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -yq install tideways-proxy \
    && apt-get -y autoremove \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && rm -rf \
        /tmp/* \
        /usr/share/doc \
        /usr/share/man \
        /usr/share/doc

EXPOSE 8137

COPY run.sh /

ENTRYPOINT [ "/run.sh" ]
