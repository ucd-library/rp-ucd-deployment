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

# Client
$GIT_CLONE $CLIENT_REPO_URL.git \
  --branch $CLIENT_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$CLIENT_REPO_NAME

# VESSEL
$GIT_CLONE $VESSEL_REPO_URL.git \
  --branch $VESSEL_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$VESSEL_REPO_NAME

# Harvest
$GIT_CLONE $HARVEST_REPO_URL.git \
  --branch $HARVEST_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$HARVEST_REPO_NAME
cd $REPOSITORY_DIR/$HARVEST_REPO_NAME
git submodule update --init --recursive
cd $ROOT_DIR/..