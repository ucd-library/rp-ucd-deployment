#! /bin/bash

##
# Generate docker-compose deployment and local development files based on
# config.sh parameters
##

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../templates

source ../config.sh

# generate main dc file
content=$(cat deployment.yaml)
for key in $(compgen -v); do
  if [[ $key == "COMP_WORDBREAKS" || $key == "content" ]]; then
    continue;
  fi
  escaped=$(printf '%s\n' "${!key}" | sed -e 's/[\/&]/\\&/g')
  content=$(echo "$content" | sed "s/{{$key}}/${escaped}/g") 
done
echo "$content" > ../docker-compose.yaml

# generate k8s files
mkdir -p ../$GKE_CONFIG_DIR

if [[ -z $INTERNAL_IP ]]; then
  echo "IP address ($IP_NAME) not set for branch $BRANCH_NAME in config.sh"
  exit -1;
fi

INDEXER_IMAGE_NAME_ESCAPED=$(echo $INDEXER_IMAGE_NAME | sed 's/\//\\\//g')
API_IMAGE_NAME_ESCAPED=$(echo $API_IMAGE_NAME | sed 's/\//\\\//g')
GATEWAY_IMAGE_NAME_ESCAPED=$(echo $GATEWAY_IMAGE_NAME | sed 's/\//\\\//g')
AUTH_IMAGE_NAME_ESCAPED=$(echo $AUTH_IMAGE_NAME | sed 's/\//\\\//g')
CLIENT_IMAGE_NAME_ESCAPED=$(echo $CLIENT_IMAGE_NAME | sed 's/\//\\\//g')
DEBOUNCER_IMAGE_NAME_ESCAPED=$(echo $DEBOUNCER_IMAGE_NAME | sed 's/\//\\\//g')
FUSEKI_IMAGE_NAME_ESCAPED=$(echo $FUSEKI_IMAGE_NAME | sed 's/\//\\\//g')
KAFKA_IMAGE_NAME_ESCAPED=$(echo $KAFKA_IMAGE_NAME | sed 's/\//\\\//g')
ELASTIC_SEARCH_IMAGE_NAME_ESCAPED=$(echo $ELASTIC_SEARCH_IMAGE_NAME | sed 's/\//\\\//g')

for file in k8s/*; do
  cat $file | \
  sed "s/{{URL}}/$URL/g" | \
  sed "s/{{INTERNAL_IP}}/$INTERNAL_IP/g" | \
  sed "s/{{CLUSTER_NAME}}/$GKE_CLUSTER_NAME/g" | \
  sed "s/{{APP_VERSION}}/$APP_VERSION/g" | \
  sed "s/{{VESSEL_TAG}}/$VESSEL_TAG/g" | \
  sed "s/{{INDEXER_IMAGE_NAME}}/$INDEXER_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{API_IMAGE_NAME}}/$API_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{GATEWAY_IMAGE_NAME}}/$GATEWAY_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{AUTH_IMAGE_NAME}}/$AUTH_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{CLIENT_IMAGE_NAME}}/$CLIENT_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{DEBOUNCER_IMAGE_NAME}}/$DEBOUNCER_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{FUSEKI_TAG}}/$FUSEKI_TAG/g" | \
  sed "s/{{FUSEKI_IMAGE_NAME}}/$FUSEKI_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{REDIS_TAG}}/$REDIS_TAG/g" | \
  sed "s/{{REDIS_IMAGE_NAME}}/$REDIS_IMAGE_NAME/g" | \
  sed "s/{{ZOOKEEPER_TAG}}/$ZOOKEEPER_TAG/g" | \
  sed "s/{{ZOOKEEPER_IMAGE_NAME}}/$ZOOKEEPER_IMAGE_NAME/g" | \
  sed "s/{{KAFKA_TAG}}/$KAFKA_TAG/g" | \
  sed "s/{{KAFKA_IMAGE_NAME}}/$KAFKA_IMAGE_NAME_ESCAPED/g" | \
  sed "s/{{ELASTIC_SEARCH_TAG}}/$ELASTIC_SEARCH_TAG/g" | \
  sed "s/{{ELASTIC_SEARCH_IMAGE_NAME}}/$ELASTIC_SEARCH_IMAGE_NAME_ESCAPED/g" > \
  "../$GKE_CONFIG_DIR/$(basename $file)"

  if [ "${file##*.}" == 'sh' ]; then
    chmod a+x "../$GKE_CONFIG_DIR/$(basename $file)"
  fi
done

# generate local development dc file
content=$(cat local-dev.yaml)
VESSEL_TAG='local-dev'
CLIENT_TAG='local-dev'
for key in $(compgen -v); do
  if [[ $key == "COMP_WORDBREAKS" || $key == "content" ]]; then
    continue;
  fi
  escaped=$(printf '%s\n' "${!key}" | sed -e 's/[\/&]/\\&/g')
  content=$(echo "$content" | sed "s/{{$key}}/${escaped}/g") 
done
if [ ! -d "../rp-local-dev" ]; then
  mkdir ../rp-local-dev
fi

echo "$content" > ../rp-local-dev/docker-compose.yaml