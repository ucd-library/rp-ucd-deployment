#! /bin/bash

######### DEPLOYMENT CONFIG ############
# Setup your application deployment here
########################################

# Main version number we are tagging the app with. Always update
# this when you cut a new version of the app!
APP_VERSION=v0.0.1

# Repository tags/branchs
# Tags should always be used for production deployments
# Branches can be used for development deployments
SCHOLARS_DISCOVERY_REPO_TAG=master
UCD_VIVO_REPO_TAG=master
UCD_SERVICE_GATEWAY_REPO_TAG=master
VIVO_HARVESTER_REPO_TAG=develop
UCD_CLIENT_REPO_TAG=master
FUSEKI_REPO_TAG=master

# Repositories
GITHUB_ORG_URL=https://github.com/ucd-library

# Scholars Discovery
SCHOLARS_DISCOVERY_REPO_NAME=scholars-discovery
SCHOLARS_DISCOVERY_REPO_URL=$GITHUB_ORG_URL/$SCHOLARS_DISCOVERY_REPO_NAME

# UCD VIVO
UCD_VIVO_REPO_NAME=rp-ucd-vivo
UCD_VIVO_REPO_URL=$GITHUB_ORG_URL/$UCD_VIVO_REPO_NAME

# FUSEKI
FUSEKI_REPO_NAME=jena-docker
FUSEKI_REPO_REPO_URL=$GITHUB_ORG_URL/$FUSEKI_REPO_NAME

# Service Gateway
UCD_SERVICE_GATEWAY_REPO_NAME=rp-ucd-service-gateway
UCD_SERVICE_GATEWAY_REPO_URL=$GITHUB_ORG_URL/$UCD_SERVICE_GATEWAY_REPO_NAME

# Harvester
VIVO_HARVESTER_REPO_NAME=Vivo_Harvester_V2
VIVO_HARVESTER_REPO_URL=$GITHUB_ORG_URL/$VIVO_HARVESTER_REPO_NAME

# Client
UCD_CLIENT_REPO_NAME=rp-ucd-client
UCD_CLIENT_REPO_URL=$GITHUB_ORG_URL/$UCD_CLIENT_REPO_NAME

# Docker Hub
UCD_LIB_DOCKER_ORG=ucdlib
DOCKER_CACHE_TAG="build-cache"

# Docker Images
SCHOLARS_DISCOVERY_BUILD_IMAGE_NAME=scholars-discovery-build
SCHOLARS_DISCOVERY_IMAGE_NAME=scholars-discovery
SCHOLARS_DISCOVERY_SOLR_IMAGE_NAME=scholars-discovery-solr
SCHOLARS_DISCOVERY_UCD_IMAGE_NAME=rp-ucd-scholars-discovery
FUSEKI_IMAGE_NAME=fuseki
VIVO_UCD_IMAGE_NAME=rp-ucd-vivo
VIVO_SOLR_IMAGE_NAME=vivo-solr
UCD_SERVICE_GATEWAY_IMAGE_NAME=rp-ucd-service-gateway
VIVO_HARVESTER_IMAGE_NAME=rp-ucd-vivo-harvester
UCD_CLIENT_IMAGE_NAME=rp-ucd-client

ALL_DOCKER_IMAGES=( $SCHOLARS_DISCOVERY_BUILD_IMAGE_NAME $SCHOLARS_DISCOVERY_IMAGE_NAME \
 $SCHOLARS_DISCOVERY_SOLR_IMAGE_NAME $SCHOLARS_DISCOVERY_UCD_IMAGE_NAME $VIVO_UCD_IMAGE_NAME \
 $VIVO_SOLR_IMAGE_NAME $UCD_SERVICE_GATEWAY_IMAGE_NAME $VIVO_HARVESTER_IMAGE_NAME \
 $UCD_CLIENT_IMAGE_NAME $FUSEKI_IMAGE_NAME )

ALL_GIT_REPOSITORIES=( $SCHOLARS_DISCOVERY_REPO_NAME $UCD_VIVO_REPO_NAME $UCD_SERVICE_GATEWAY_REPO_NAME \
 $VIVO_HARVESTER_REPO_NAME $UCD_CLIENT_REPO_NAME $FUSEKI_REPO_NAME )

# Git
GIT=git
GIT_CLONE="$GIT clone"

# directory we are going to cache our various git repos at different tags
# if using pull.sh or the directory we will look for repositories (can by symlinks)
# if local development
REPOSITORY_DIR=repositories