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

# VESSEL
$GIT_CLONE $VESSEL_REPO_URL.git \
  --branch $VESSEL_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME

# Client
$GIT_CLONE $CLIENT_REPO_URL.git \
  --branch $CLIENT_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$CLIENT_REPO_NAME