#!/usr/bin/env bash

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE=`date +%Y-%m-%dT%T%z`

SCRIPT_DIR=$(dirname "$0")

if [[ -z "$GROUP" ]] ; then
    echo "Cannot find GROUP env var"
    exit 1
fi

COMMIT=$(git log -1 | head -n1 | awk '{print $2}');

if [[ -z "$COMMIT" ]] ; then
    echo "Cannot find COMMIT env var"
    exit 1
fi

#if [[ "$(uname)" == "Darwin" ]]; then
DOCKER_CMD=docker
#else
#    DOCKER_CMD="sudo docker"
#fi
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR
 
cp -r $CODE_DIR/images/ $CODE_DIR/docker/catalogue/images/
cp -r $CODE_DIR/cmd/ $CODE_DIR/docker/catalogue/cmd/
cp $CODE_DIR/*.go $CODE_DIR/docker/catalogue/
mkdir -p $CODE_DIR/docker/catalogue/vendor && cp $CODE_DIR/vendor/manifest $CODE_DIR/docker/catalogue/vendor/

REPO=${GROUP}/$(basename catalogue);

$DOCKER_CMD build -t ${REPO}-dev $CODE_DIR/docker/catalogue;
$DOCKER_CMD create --name catalogue ${REPO}-dev;
$DOCKER_CMD cp catalogue:/app/main $CODE_DIR/docker/catalogue/app;
$DOCKER_CMD rm catalogue;
$DOCKER_CMD build \
  --build-arg BUILD_VERSION=$BUILD_VERSION \
  --build-arg BUILD_DATE=$BUILD_DATE \
  --build-arg COMMIT=$COMMIT \
  -t ${REPO}:${COMMIT} \
  -f $CODE_DIR/docker/catalogue/Dockerfile-release $CODE_DIR/docker/catalogue;

$DOCKER_CMD build \
  -t ${REPO}-db:${COMMIT} \
  -f $CODE_DIR/docker/catalogue-db/Dockerfile $CODE_DIR/docker/catalogue-db;
