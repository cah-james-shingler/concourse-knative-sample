#!/bin/bash

set +x

. knative-deployment/ci/tasks/setup.sh

setup_kubectl
# echo $CONFIG > key.json
# gcloud auth activate-service-account --key-file=key.json --quiet
# gcloud config set project $PROJECT_NAME
# gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

# kubectl version

kubectl apply -f knative-deployment/service.yaml
