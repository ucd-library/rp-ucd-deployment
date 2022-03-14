#! /bin/bash

###
# Main build process to cutting production images
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

# Use buildkit to speedup local builds
# Not supported in google cloud build yet
if [[ -z $CLOUD_BUILD ]]; then
  export DOCKER_BUILDKIT=1
fi

VESSEL_REPO_HASH=$(git -C $REPOSITORY_DIR/$VESSEL_REPO_NAME log -1 --pretty=%h)
CLIENT_REPO_HASH=$(git -C $REPOSITORY_DIR/$CLIENT_REPO_NAME log -1 --pretty=%h)

##
# Vessel
##

# nodejs services
docker build \
  -t $NODE_SERVICES_IMAGE_NAME_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --cache-from=$NODE_SERVICES_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/node-services

# kafka init
docker build \
  -t $KAFKA_INIT_IMAGE_NAME_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg KAFKA_IMAGE=${KAFKA_IMAGE_NAME}:${KAFKA_TAG} \
  --cache-from=$KAFKA_INIT_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/kafka-init

##
# Client
##

docker build \
  -t $CLIENT_IMAGE_NAME_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg NODEJS_BASE=${NODE_SERVICES_IMAGE_NAME_TAG} \
  --build-arg CLIENT_TAG=${CLIENT_TAG} \
  --build-arg VESSEL_TAG=${VESSEL_TAG} \
  --build-arg BUILD_NUM=${BUILD_NUM} \
  --build-arg BUILD_TIME=${BUILD_TIME} \
  --build-arg APP_VERSION=${APP_VERSION} \
  --cache-from=$CLIENT_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  $REPOSITORY_DIR/$CLIENT_REPO_NAME
