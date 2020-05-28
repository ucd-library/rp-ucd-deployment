#! /bin/bash

###
# Shallow clone repositories defined in config.sh
# WARNING: Used for gcloud builds.  This wipes
# respositories folders and starts fresh every time
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

if [ -d $REPOSITORY_DIR ] ; then
  rm -rf $REPOSITORY_DIR
fi
mkdir -p $REPOSITORY_DIR

# Scholars Discovery
$GIT_CLONE $SCHOLARS_DISCOVERY_REPO_URL.git \
  --branch $SCHOLARS_DISCOVERY_REPO_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$SCHOLARS_DISCOVERY_REPO_NAME

# UCD VIVO and Scholars
$GIT_CLONE $UCD_VIVO_REPO_URL.git \
  --branch $UCD_VIVO_REPO_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$UCD_VIVO_REPO_NAME

# UCD Service Gateway
$GIT_CLONE $UCD_SERVICE_GATEWAY_REPO_URL.git \
  --branch $UCD_SERVICE_GATEWAY_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$UCD_SERVICE_GATEWAY_REPO_NAME