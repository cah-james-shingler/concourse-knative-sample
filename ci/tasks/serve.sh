#!/bin/bash

echo $CONFIG > key.json

gcloud auth activate-service-account --key-file=key.json

gcloud config set project $PROJECT_NAME

gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

# Build the container on your local machine
docker build -t ((username))/helloworld-go .

# Push the container to docker registry
docker push ((username))/helloworld-go

kubectl version

kubectl apply -f knative-test/serve.yaml

