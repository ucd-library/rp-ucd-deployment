#! /bin/bash

###
# Pull :latest docker images to help speed up builds
# Mostly used for gcloud build.  But can be used for 
# first time local builds as well
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

for image in "${ALL_DOCKER_IMAGES[@]}"; do
  docker pull $UCD_LIB_DOCKER_ORG/$image:$DOCKER_CACHE_TAG || true
done

docker pull docker.io/library/maven:3-jdk-8-slim