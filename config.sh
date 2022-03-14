#! /bin/bash

######### DEPLOYMENT CONFIG ############
# Setup your application deployment here
########################################

# Grab build number is mounted in CI system
if [[ -f /config/.buildenv ]]; then
  source /config/.buildenv
else
  BUILD_NUM=-1
fi


# Main version number we are tagging the app with. Always update
# this when you cut a new version of the app!
APP_VERSION=v1.7.0-alpha.${BUILD_NUM}

##
# TAGS
##

# Repository tags/branchs
# Tags should always be used for production deployments
# Branches can be used for development deployments
VESSEL_TAG=jm-gcs
CLIENT_TAG=sandbox

FUSEKI_TAG=1.4.0
REDIS_TAG=6.0.5
ZOOKEEPER_TAG=3.6
KAFKA_TAG=2.5.0
ELASTIC_SEARCH_TAG=7.8.0

##
# Repositories
##

GITHUB_ORG_URL=https://github.com/ucd-library

# VESSEL
VESSEL_REPO_NAME=vessel
VESSEL_REPO_URL=$GITHUB_ORG_URL/$VESSEL_REPO_NAME

# RP Client
CLIENT_REPO_NAME=rp-ucd-client
CLIENT_REPO_URL=$GITHUB_ORG_URL/$CLIENT_REPO_NAME

##
# Container
##

# Container Registery
CONTAINER_REG_ORG=gcr.io/ucdlib-pubreg
CONTAINER_CACHE_TAG='latest'

if [[ ! -z $LOCAL_BUILD ]]; then
  CONTAINER_REG_ORG=local-dev/ucdlib
fi

# Container Images
FUSEKI_IMAGE_NAME=gcr.io/ucdlib-pubreg/rp-ucd-fuseki
CLIENT_IMAGE_NAME=$CONTAINER_REG_ORG/rp-ucd-client
NODE_SERVICES_IMAGE_NAME=$CONTAINER_REG_ORG/rp-ucd-node-services
KAFKA_INIT_IMAGE_NAME=$CONTAINER_REG_ORG/rp-kafka-init

CLIENT_IMAGE_NAME_TAG=$CLIENT_IMAGE_NAME:$CLIENT_TAG
NODE_SERVICES_IMAGE_NAME_TAG=$NODE_SERVICES_IMAGE_NAME:$VESSEL_TAG
KAFKA_INIT_IMAGE_NAME_TAG=$KAFKA_INIT_IMAGE_NAME:$VESSEL_TAG

REDIS_IMAGE_NAME=redis
ZOOKEEPER_IMAGE_NAME=zookeeper
KAFKA_IMAGE_NAME=bitnami/kafka
ELASTIC_SEARCH_IMAGE_NAME=docker.elastic.co/elasticsearch/elasticsearch

ALL_DOCKER_BUILD_IMAGES=( $CLIENT_IMAGE_NAME  \
 $NODE_SERVICES_IMAGE_NAME $KAFKA_INIT_IMAGE_NAME )

ALL_DOCKER_BUILD_IMAGE_TAGS=($CLIENT_IMAGE_NAME_TAG \
 $NODE_SERVICES_IMAGE_NAME_TAG $KAFKA_INIT_IMAGE_NAME_TAG )

##
# Google Kubernetes Engine (GKE)
##

# GKE_PROJECT_ID=digital-ucdavis-edu
# GKE_REGION=us-central1
# GKE_ZONE=${GKE_REGION}-a
# if [[ -z $BRANCH_NAME ]]; then
#   GKE_CLUSTER_NAME=$(git rev-parse --abbrev-ref HEAD)
# else
#   GKE_CLUSTER_NAME=$BRANCH_NAME
# fi
# GKE_CLUSTER_NAME="rp-${GKE_CLUSTER_NAME}"
# GKE_CLUSTER_VERSION=1.14.10
# GKE_CONFIG_DIR=k8s

# Main cluser IP addresses.  Tied to branch name.
# see ./cmds/k8s/get-new-internal-ip.sh if setting up new cluster

# master_IP="10.128.0.21"

# IP_NAME="${GKE_CLUSTER_NAME}_IP"
# INTERNAL_IP=${!IP_NAME}

##
# Git
##

ALL_GIT_REPOSITORIES=( $VESSEL_REPO_NAME $CLIENT_REPO_NAME )
ALL_GIT_REPOSITORY_TAGS=( "$VESSEL_REPO_URL@$VESSEL_TAG" \
 "$CLIENT_REPO_URL@$CLIENT_TAG" )

# Git
GIT=git
GIT_CLONE="$GIT clone"

# directory we are going to cache our various git repos at different tags
# if using pull.sh or the directory we will look for repositories (can by symlinks)
# if local development
REPOSITORY_DIR=repositories
