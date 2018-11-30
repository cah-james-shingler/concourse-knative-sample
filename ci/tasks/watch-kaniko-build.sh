#!/bin/bash

PODNAME=$(kubectl get build kaniko-build -ojsonpath='{.status.cluster.podName}')

echo "Pod name: $PODNAME"
kubectl logs -f -p $PODNAME -c build-step-credential-initializer
kubectl logs -f -p $PODNAME -c build-step-git-source
kubectl logs -f -p $PODNAME -c build-step-build-and-push

status=$(kubectl get po -l build.knative.dev/buildName=kaniko-build -o=jsonpath='{..status.phase}')

if [ $status == "Succeeded" ]; then
  echo "Build $status."
  exit 0
else
  >&2 echo "Build $status."
  exit 1
fi

