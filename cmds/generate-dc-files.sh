#! /bin/bash

##
# Generate docker-compose deployment and local development files based on
# config.sh parameters
##

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../dc-templates

TEMPLATE_VAR_ARRAY=("SCHOLARS_DISCOVERY_REPO_TAG" "UCD_VIVO_REPO_TAG" "APP_VERSION"
  "UCD_SERVICE_GATEWAY_REPO_TAG")

source ../config.sh

content=$(cat deployment.yaml)
for key in ${TEMPLATE_VAR_ARRAY[@]}; do
  content=$(echo "$content" | sed "s/{{$key}}/${!key}/g") 
done
echo "$content" > ../docker-compose.yaml

content=$(cat local-dev.yaml)
for key in ${TEMPLATE_VAR_ARRAY[@]}; do
  content=$(echo "$content" | sed "s/{{$key}}/local-dev/g") 
done
if [ ! -d "../rp-local-dev" ]; then
  mkdir ../rp-local-dev
fi

echo "$content" > ../rp-local-dev/docker-compose.yaml