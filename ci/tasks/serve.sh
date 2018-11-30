#!/bin/bash

set +x

echo $CONFIG > key.json
gcloud auth activate-service-account --key-file=key.json --quiet
gcloud config set project $PROJECT_NAME
gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

kubectl version

kubectl apply -f knative-test/service.yaml
