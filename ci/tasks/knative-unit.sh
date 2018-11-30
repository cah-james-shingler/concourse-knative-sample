#!/bin/bash

echo "Setting up kubectl to point to cluster '$CLUSTER_NAME'"
echo $CONFIG > key.json

gcloud auth activate-service-account --key-file=key.json --quiet

gcloud config set project $PROJECT_NAME

gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

echo "Creating new test build"
# kubectl apply -f knative-test/go-test-buildtemplate.yaml
kubectl apply -f knative-test/go-run-test.yaml

sleep 5

PODNAME=$(kubectl get build go-unit-test -ojsonpath='{.status.cluster.podName}')

echo "Build pod name: $PODNAME"

containerNames=(build-step-credential-initializer build-step-git-source build-step-go-unit-test)

for i in "${!containerNames[@]}"; do
  echo $i;
  status=$(kubectl get build go-unit-test -ojson | jq --arg index $i -r '.status.stepStates[$index | tonumber]' | jq 'keys[]');
  while [ status == "waiting" ]; do
    echo "Waiting for ${containerNames[i]}";
    sleep 5
  done
  kubectl logs -f $PODNAME -c ${containerNames[i]}
done

pod_status="Pending"

while [ pod_status == "Pending" ]; do
  pod_status=$(kubectl get po -l build.knative.dev/buildName=go-unit-test -o=jsonpath='{..status.phase}')
  sleep 2
done

if [ $pod_status == "Succeeded" ]; then
  echo "Build $pod_status."
  exit 0
else
  >&2 echo "Build $status."
  exit 1
fi

