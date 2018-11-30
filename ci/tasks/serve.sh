#!/bin/bash

set +x

echo $CONFIG > key.json
gcloud auth activate-service-account --key-file=key.json --quiet
gcloud config set project $PROJECT_NAME
gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

pushd helloworld-go
  # Build the container on your local machine
  docker build -t ddadlani/helloworld-go .

  # Push the container to docker registry
  docker push ddadlani/helloworld-go
popd

kubectl version

kubectl apply -f knative-test/serve.yaml
