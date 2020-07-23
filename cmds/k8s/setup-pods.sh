#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ../../config.sh

cd ../../${GKE_CONFIG_DIR}

gcloud container clusters get-credentials ${GKE_CLUSTER_NAME}  \
  --zone ${GKE_ZONE} \
  --project ${GKE_PROJECT_ID}

# create the main server deployment
kubectl delete statefulset elasticsearch
kubectl apply -f elasticsearch.statefulset.yaml
kubectl apply -f elasticsearch.service.yaml