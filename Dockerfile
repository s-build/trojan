FROM alpine:latest as builder

ENV TZ=Asia/Shanghai

WORKDIR /trojan/
copy . /trojan/

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        cmake \
        boost-dev \
        openssl-dev \
        mariadb-connector-c-dev \
    && (cd /trojan && cmake . && make -j $(nproc) && strip -s trojan \
    && mv trojan /trojan/) \
    && rm -rf trojan \
    && apk del .build-deps \
    && apk add --no-cache --virtual .trojan-rundeps \
        libstdc++ \
        boost-system \
        boost-program_options \
        mariadb-connector-c


CMD ["/trojan/trojan", "config.json"]
