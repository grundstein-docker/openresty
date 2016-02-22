# wizardsatwork/grundstein/openresty dockerfile
# VERSION 0.0.1

FROM alpine:3.3

MAINTAINER Wizards & Witches <dev@wiznwit.com>
ENV REFRESHED_AT 2016-21-02

ARG TARGET_DIR
ARG VERSION
ARG SBIN
ARG PORT_80
ARG PORT_443

ENV PATH ${SBIN}:$EXPORT_PATH:$PATH
ENV LUA_PATH ?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/share/lua/5.1/init.lua;;
ENV LUA_CPATH ?;?.so;/usr/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?/init.so;/usr/lib/lua/5.1/init.so;;

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --update --virtual build-deps \
  ca-certificates \
  pcre \
  libgcc \
  geoip \
  build-base \
  readline-dev \
  ncurses-dev \
  pcre-dev \
  zlib-dev \
  openssl-dev \
  perl \
  wget \
  curl \
  make \
  tar \
  geoip-dev \
  git \
  unzip \
  openrc \
  lua5.1 \
  lua5.1-dev \
  luarocks5.1

RUN rm -rf /var/cache/apk/*

#install openresty
RUN \
  mkdir /build_tmp \
  && cd /build_tmp \
  && wget http://openresty.org/download/ngx_openresty-${VERSION}.tar.gz \
  && tar xf ngx_openresty-${VERSION}.tar.gz \
  && cd ngx_openresty-${VERSION} \
  && ./configure \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-luajit \
    --with-http_addition_module \
    --with-http_sub_module \
  && make \
  && make install \
  && rm -rf /build_tmp

RUN luarocks-5.1 install lapis

# add sources
ADD ./out ${TARGET_DIR}

# add log directory and pipe it to stdout
RUN mkdir -p ${TARGET_DIR}/logs \
  && ln -sf /dev/stdout ${TARGET_DIR}/logs/access.log

# Expose ports
EXPOSE ${PORT_80} ${PORT_443}

WORKDIR ${TARGET_DIR}

CMD ["lapis", "server", "production"]
