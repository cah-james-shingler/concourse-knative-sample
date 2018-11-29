#!/bin/bash

. knative-test/ci/tasks/setup.sh

setup_kubectl

kubectl logs -l build.knative.dev/buildName=kaniko-build -c build-step-credential-initializer
kubectl logs -l build.knative.dev/buildName=kaniko-build -c build-step-git-source
kubectl logs -l build.knative.dev/buildName=kaniko-build -c build-step-build-and-push

kubectl get build kaniko-build -ojson

status=$(kubectl get po -l build.knative.dev/buildName=kaniko-build -o=jsonpath='{..status.phase}')

if [ $status == "Succeeded" ]; then
  echo "Build succeeded."
  exit 0
else
  >&2 echo "Build failed."
  exit 1
fi

