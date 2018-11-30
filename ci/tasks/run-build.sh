#!/bin/bash

echo "Setting up kubectl to point to cluster '$CLUSTER_NAME'"
echo $CONFIG > key.json

gcloud auth activate-service-account --key-file=key.json --quiet

gcloud config set project $PROJECT_NAME

gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

echo "Creating new test build"
kubectl apply -f knative-test/$BUILD_NAME.yaml

sleep 5

PODNAME=$(kubectl get build $BUILD_NAME -ojsonpath='{.status.cluster.podName}')

echo "Build pod name: $PODNAME"

containerNames=($(kubectl get po -l build.knative.dev/buildName=$BUILD_NAME -ojson | jq -r '.items[0].status.initContainerStatuses | values[].name'))

for i in ${!containerNames[@]}; do
  echo -e "\ncontainer ${containerNames[i]}:"
  status=$(kubectl get build $BUILD_NAME -ojson | jq --arg index $i -r '.status.stepStates[$index | tonumber]' | jq 'keys[]');
  while [ status == "waiting" ]; do
    echo "Waiting for ${containerNames[i]}";
    sleep 5
  done
  kubectl logs -f $PODNAME -c ${containerNames[i]}
done

pod_status="Pending"

while [[ "$pod_status" == "Pending" || "$pod_status" == "Running" ]] ; do
  pod_status=$(kubectl get po -l build.knative.dev/buildName=$BUILD_NAME -o=jsonpath='{..status.phase}')
  sleep 2
done

if [ $pod_status == "Succeeded" ]; then
  echo "Build $pod_status."
  exit 0
else
  >&2 echo "Build $pod_status."
  exit 1
fi

