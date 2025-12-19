FROM --platform=linux/arm64 postgres:18-alpine

LABEL maintainer="PostGIS Project - ARM64 Build"

ENV POSTGIS_VERSION=3.6.1
ENV POSTGIS_MAJOR=3

# Install runtime dependencies first
RUN set -ex \
    && apk add --no-cache \
        gdal \
        geos \
        proj \
        protobuf-c \
        json-c \
        libxml2 \
        pcre2

# Install build dependencies
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
        gcc \
        make \
        cmake \
        autoconf \
        automake \
        libtool \
        pkgconfig

# Build PostGIS from source
RUN set -eux \
    && cd /usr/src \
    && git clone --depth 1 --branch ${POSTGIS_VERSION} https://github.com/postgis/postgis.git \
    && cd postgis

# Run autogen
RUN cd /usr/src/postgis \
    && ./autogen.sh

# Configure PostGIS
RUN cd /usr/src/postgis \
    && ./configure \
        --with-pgconfig=/usr/bin/pg_config \
        --with-gdalconfig=/usr/bin/gdal-config \
        --with-geosconfig=/usr/bin/geos-config \
        --with-projdir=/usr \
        --with-protobufdir=/usr \
        --with-jsondir=/usr \
    || (echo "Configure failed, showing config.log:" && cat config.log && exit 1)

# Build PostGIS
RUN cd /usr/src/postgis \
    && (make -j1 2>&1 | tee /tmp/build.log) || (echo "=== Make failed, showing last 100 lines ===" && tail -100 /tmp/build.log && echo "=== End of error log ===" && exit 1)

# Install PostGIS
RUN cd /usr/src/postgis \
    && make install

# Clean up source
RUN rm -rf /usr/src/postgis

# Clean up build dependencies
RUN set -ex \
    && apk del .fetch-deps .build-deps \
    && rm -rf /var/cache/apk/*

# Copy initialization scripts
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/update-postgis.sh

