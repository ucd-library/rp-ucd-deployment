
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../../config.sh

# reserve address to expose webapp internaly
gcloud compute addresses create ${GKE_CLUSTER_NAME}-server-ip \
  --subnet default \
  --region ${GKE_REGION}

# print info about new address
gcloud compute addresses describe ${GKE_CLUSTER_NAME}-server-ip \
  --region ${GKE_REGION}