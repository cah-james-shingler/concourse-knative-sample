#!/bin/bash

echo "Setting up kubectl to point to cluster '$CLUSTER_NAME'"
echo $CONFIG > key.json

gcloud auth activate-service-account --key-file=key.json --quiet

gcloud config set project $PROJECT_NAME

gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

echo "Creating new build"
kubectl apply -f knative-test/build-kaniko.yaml

PODNAME=$(kubectl get build kaniko-build -ojsonpath='{.status.cluster.podName}')

echo "Build pod name: $PODNAME"

kubectl logs -f $PODNAME -c build-step-credential-initializer
kubectl logs -f $PODNAME -c build-step-git-source
kubectl logs -f $PODNAME -c build-step-build-and-push

status=$(kubectl get po -l build.knative.dev/buildName=kaniko-build -o=jsonpath='{..status.phase}')

if [ $status == "Succeeded" ]; then
  echo "Build $status."
  exit 0
else
  >&2 echo "Build $status."
  exit 1
fi

