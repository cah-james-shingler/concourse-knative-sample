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

containerNames=(build-step-credential-initializer build-step-git-source build-step-build-and-push)
for i in `seq 0 2`
do
  status=$(kubectl get po -l build.knative.dev/buildName=kaniko-build -ojson | jq -r '.status.stepStates[$($i+1)]' | jq 'keys[]')
  while [ status == "waiting" ]; do
    echo "Waiting for container ${containerNames[$i]}
    sleep(2)
  done
  kubectl logs -f $PODNAME -c ${containerNames[$i]}
done


# status=$(kubectl get po -l build.knative.dev/buildName=kaniko-build -o=jsonpath='{..status.phase}')
# until [ $status != "Pending" ]; do
#   echo "Waiting for pod to be running"
#   status=$(kubectl get po -l build.knative.dev/buildName=kaniko-build -o=jsonpath='{..status.phase}')
# done
# kubectl logs -f $PODNAME -c build-step-credential-initializer
# kubectl logs -f $PODNAME -c build-step-git-source
# kubectl logs -f $PODNAME -c build-step-build-and-push

status=$(kubectl get po -l build.knative.dev/buildName=kaniko-build -o=jsonpath='{..status.phase}')

if [ $status == "Succeeded" ]; then
  echo "Build $status."
  exit 0
else
  >&2 echo "Build $status."
  exit 1
fi

