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

# Additionally set local-dev tags used by 
# local development docker-compose file
if [[ ! -z $LOCAL_BUILD ]]; then
  VESSEL_TAG='local-dev'
  CLIENT_TAG='local-dev'
fi

VESSEL_REPO_HASH=$(git -C $REPOSITORY_DIR/$VESSEL_REPO_NAME log -1 --pretty=%h)
CLIENT_REPO_HASH=$(git -C $REPOSITORY_DIR/$CLIENT_REPO_NAME log -1 --pretty=%h)

##
# Vessel
##

NODEJS_BASE=$NODE_UTILS_IMAGE_NAME:$VESSEL_TAG

# nodejs baselayer
docker build \
  -t $NODEJS_BASE \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --cache-from=$NODE_UTILS_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/node-utils

# kafka rdf-patch debouncer
docker build \
  -t $DEBOUNCER_IMAGE_NAME:$VESSEL_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  --cache-from=$DEBOUNCER_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/debouncer

# elastic search indexer
docker build \
  -t $INDEXER_IMAGE_NAME:$VESSEL_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  --cache-from=$INDEXER_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/es-indexer

# elastic search api
docker build \
  -t $API_IMAGE_NAME:$VESSEL_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  --cache-from=$API_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/api

# auth
docker build \
  -t $AUTH_IMAGE_NAME:$VESSEL_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  --cache-from=$AUTH_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/auth-cas

# gateway
docker build \
  -t $GATEWAY_IMAGE_NAME:$VESSEL_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  --cache-from=$GATEWAY_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME/gateway

##
# Client
##

docker build \
  -t $CLIENT_IMAGE_NAME:$CLIENT_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  --cache-from=$CLIENT_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$CLIENT_REPO_NAME
