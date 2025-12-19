FROM postgres:18-alpine

LABEL maintainer="PostGIS Project - ARM64 Build"

ENV POSTGIS_VERSION=3.6
ENV POSTGIS_MAJOR=3

# Install PostGIS dependencies and PostGIS itself
RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        tar \
        git \
    && apk add --no-cache --virtual .build-deps \
        postgresql-dev \
        gdal-dev \
        geos-dev \
        proj-dev \
        protobuf-c-dev \
        json-c-dev \
        libxml2-dev \
        pcre2-dev \
        perl \
        g++ \
        make \
        cmake \
        autoconf \
        automake \
        libtool \
    && apk add --no-cache \
        gdal \
        geos \
        proj \
        protobuf-c \
        json-c \
        libxml2 \
        pcre2 \
    && cd /usr/src \
    && git clone --depth 1 --branch ${POSTGIS_VERSION} https://github.com/postgis/postgis.git \
    && cd postgis \
    && ./autogen.sh \
    && ./configure \
        --with-pgconfig=/usr/bin/pg_config \
        --with-gdalconfig=/usr/bin/gdal-config \
        --with-geosconfig=/usr/bin/geos-config \
        --with-projdir=/usr \
        --with-protobufdir=/usr \
        --with-jsondir=/usr \
    && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf /usr/src/postgis \
    && apk del .fetch-deps .build-deps \
    && rm -rf /var/cache/apk/*

# Copy initialization scripts
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/update-postgis.sh

