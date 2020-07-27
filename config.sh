#! /bin/bash

######### DEPLOYMENT CONFIG ############
# Setup your application deployment here
########################################

# Main version number we are tagging the app with. Always update
# this when you cut a new version of the app!
APP_VERSION=v0.0.2

##
# TAGS
##

# Repository tags/branchs
# Tags should always be used for production deployments
# Branches can be used for development deployments
VESSEL_TAG=master
CLIENT_TAG=dev

FUSEKI_TAG=jena-3.15.0-c-0.0.3
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
# Docker
##

# Docker Hub
UCD_LIB_DOCKER_ORG=ucdlib
DOCKER_CACHE_TAG="latest"

# Docker Images
FUSEKI_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-fuseki
CLIENT_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-client
NODE_UTILS_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-node-utils
DEBOUNCER_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-kafka-debouncer
INDEXER_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-es-indexer
API_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-api
GATEWAY_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-gateway
AUTH_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/rp-ucd-auth-cas

REDIS_IMAGE_NAME=redis
ZOOKEEPER_IMAGE_NAME=zookeeper
KAFKA_IMAGE_NAME=bitnami/kafka
ELASTIC_SEARCH_IMAGE_NAME=docker.elastic.co/elasticsearch/elasticsearch

ALL_DOCKER_BUILD_IMAGES=( $CLIENT_IMAGE_NAME $DEBOUNCER_IMAGE_NAME \
 $INDEXER_IMAGE_NAME $API_IMAGE_NAME $GATEWAY_IMAGE_NAME $NODE_UTILS_IMAGE_NAME \
 $AUTH_IMAGE_NAME )

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

# Git
GIT=git
GIT_CLONE="$GIT clone"

# directory we are going to cache our various git repos at different tags
# if using pull.sh or the directory we will look for repositories (can by symlinks)
# if local development
REPOSITORY_DIR=repositories