#! /bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../../config.sh

# Create cluster via cli with default pool
gcloud beta container clusters create ${GKE_CLUSTER_NAME} \
  --zone us-central1-a \
  --num-nodes 4 \
  --disk-size 25GB \
  --machine-type n1-standard-1 \
  --cluster-version=${GKE_CLUSTER_VERSION} \
  --node-labels=intendedfor=default-pool

# additional pool sample.  not using yet
# gcloud beta container node-pools create worker-pool \
#   --cluster ${GKE_CLUSTER_NAME} \
#   --machine-type n1-highmem-4 \
#   --preemptible \
#   --num-nodes 1 \
#   --disk-size 200GB \
#   --enable-autoscaling --min-nodes 1 --max-nodes 201 \
#   --node-labels=intendedfor=workers


# setup kubectl to connect to cluster
gcloud container clusters get-credentials ${GKE_CLUSTER_NAME}  \
  --zone ${GKE_ZONE} \
  --project ${GKE_PROJECT_ID}