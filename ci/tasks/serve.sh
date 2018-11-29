#!/bin/bash

set +x

echo $CONFIG > key.json

pushd helloworld-go
  # Build the container on your local machine
  docker build -t ddadlani/helloworld-go .

  # Push the container to docker registry
  docker push ddadlani/helloworld-go
popd

kubectl version

kubectl apply -f knative-test/serve.yaml
