#! /bin/bash

###
# Push docker image and $DOCKER_CACHE_TAG (currently :latest) tag to docker hub
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

docker push $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_BUILD_IMAGE_NAME:$SCHOLARS_DISCOVERY_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_BUILD_IMAGE_NAME:$SCHOLARS_DISCOVERY_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_BUILD_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_IMAGE_NAME:$SCHOLARS_DISCOVERY_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_IMAGE_NAME:$SCHOLARS_DISCOVERY_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_SOLR_IMAGE_NAME:$SCHOLARS_DISCOVERY_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_SOLR_IMAGE_NAME:$SCHOLARS_DISCOVERY_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_SOLR_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_UCD_IMAGE_NAME:$UCD_VIVO_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_UCD_IMAGE_NAME:$UCD_VIVO_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$SCHOLARS_DISCOVERY_UCD_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$VIVO_UCD_IMAGE_NAME:$UCD_VIVO_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$VIVO_UCD_IMAGE_NAME:$UCD_VIVO_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$VIVO_UCD_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$VIVO_SOLR_IMAGE_NAME:$UCD_VIVO_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$VIVO_SOLR_IMAGE_NAME:$UCD_VIVO_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$VIVO_SOLR_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$UCD_SERVICE_GATEWAY_IMAGE_NAME:$UCD_SERVICE_GATEWAY_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$UCD_SERVICE_GATEWAY_IMAGE_NAME:$UCD_SERVICE_GATEWAY_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$UCD_SERVICE_GATEWAY_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$VIVO_HARVESTER_IMAGE_NAME:$VIVO_HARVESTER_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$VIVO_HARVESTER_IMAGE_NAME:$VIVO_HARVESTER_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$VIVO_HARVESTER_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_DOCKER_ORG/$UCD_CLIENT_IMAGE_NAME:$UCD_CLIENT_REPO_TAG
docker tag $UCD_LIB_DOCKER_ORG/$UCD_CLIENT_IMAGE_NAME:$UCD_CLIENT_REPO_TAG \
  $UCD_LIB_DOCKER_ORG/$UCD_CLIENT_IMAGE_NAME:$DOCKER_CACHE_TAG

for image in "${ALL_DOCKER_IMAGES[@]}"; do
  docker push $UCD_LIB_DOCKER_ORG/$image:$DOCKER_CACHE_TAG || true
done