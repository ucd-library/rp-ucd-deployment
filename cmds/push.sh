#! /bin/bash

###
# Push docker image and $DOCKER_CACHE_TAG (currently :latest) tag to docker hub
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

docker tag $CLIENT_IMAGE_NAME_TAG $CLIENT_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $HARVEST_IMAGE_NAME_TAG $HARVEST_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $NODE_UTILS_IMAGE_NAME_TAG $NODE_UTILS_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $DEBOUNCER_IMAGE_NAME_TAG $DEBOUNCER_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $INDEXER_IMAGE_NAME_TAG $INDEXER_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $MODEL_IMAGE_NAME_TAG $MODEL_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $API_IMAGE_NAME_TAG $API_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $AUTH_IMAGE_NAME_TAG $AUTH_IMAGE_NAME:$DOCKER_CACHE_TAG
docker tag $GATEWAY_IMAGE_NAME_TAG $GATEWAY_IMAGE_NAME:$DOCKER_CACHE_TAG

for image in "${ALL_DOCKER_BUILD_IMAGE_TAGS[@]}"; do
  docker push $image || true
done

for image in "${ALL_DOCKER_BUILD_IMAGES[@]}"; do
  docker push $image:$DOCKER_CACHE_TAG || true
done