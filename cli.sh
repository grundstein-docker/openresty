#!/bin/bash

OUT_DIR="$PWD/out"
SRC_DIR="$PWD/src"
NGINX_SRC_DIR="$SRC_DIR/nginx"
LUA_SRC_DIR="$SRC_DIR/lua"
LIB_NAME=resty

source ./ENV.sh
source ./IPS.sh
source ../bin/tasks.sh

echo "container: $CONTAINER_NAME"

function build {
  echo "build $CONTAINER_NAME"

  asset-build
  moon-build
  nginx-build

  docker build \
    --tag=$CONTAINER_NAME \
    --build-arg="TARGET_DIR=$TARGET_DIR" \
    --build-arg="PORT_80=$CONTAINER_PORT_80" \
    --build-arg="PORT_443=$CONTAINER_PORT_443" \
    --build-arg="VERSION=$VERSION" \
    --build-arg="SBIN=$SBIN" \
    . # dot!

  echo "build done"
}

function run() {
  remove

  echo "starting container"

  docker run \
    --detach \
    --name $CONTAINER_NAME \
    --publish $HOST_PORT_80:$CONTAINER_PORT_80 \
    --publish $HOST_PORT_443:$CONTAINER_PORT_443 \
    $CONTAINER_NAME
}

function asset-build() {
  echo "copying assets from $SRC_DIR to $OUT_DIR"
  mkdir -p $OUT_DIR
  cp -r $SRC_DIR/assets/ $OUT_DIR
}

function nginx-build() {
  echo "building nginx sources"

  mkdir -p $OUT_DIR/
  cp -r $NGINX_SRC_DIR/* $OUT_DIR/
  sed \
    --in-place \
    -e "s/|HOST_IP|/$MAGIC_GITLAB_IP/g" \
    $OUT_DIR/sites-enabled/gitlab

  sed \
    --in-place \
    -e "s/|HOST_IP|/$MAGIC_REDMINE_IP/g" \
    $OUT_DIR/sites-enabled/redmine

  echo "nginx config finished"
}

function moon-build() {
  mkdir -p $OUT_DIR;
  moonc \
    -t $OUT_DIR/ \
    $LUA_SRC_DIR/*
}

function moon-watch() {
  moonc \
    -w src/* \
    -o $OUT_DIR/$LIB_NAME.lua \
    $LUA_SRC_DIR/$LIB_NAME.moon
}

function moon-lint() {
  moonc -l $LUA_SRC_DIR/*
}

function clean() {
  echo "cleaning up"

  rm -rf ./out
}

function help() {
  echo "Container: $CONTAINER_NAME"
  echo ""
  echo "USAGE:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "build  - docker builds the container"
  echo "run    - docker runs the container"
  echo "remove - docker remove the container"
  echo "clean  - rm the out directory"
  echo "logs   - tail the docker logs"
  echo "debug  - connect to the container"
  echo ""
  echo "lua commands:"
  echo "moon-build - build lua/moon sources"
  echo "moon-lint  - run lua/moon linter"
  echo "moon-watch - start lua watch task"
  echo "clean      - remove lua build"
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi
