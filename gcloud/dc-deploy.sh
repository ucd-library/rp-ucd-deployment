#! /bin/bash

set -e

CLUSTER_NAME="rp-${BRANCH_NAME}"

echo "USER:$USER";
echo "BRANCH_NAME:${BRANCH_NAME}";
echo "CLUSTER_NAME:${CLUSTER_NAME}";

cd /opt/${CLUSTER_NAME}
git reset HEAD --hard
git checkout ${BRANCH_NAME}
git pull

docker-compose pull
docker-compose down
docker-compose up -d