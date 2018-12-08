#!/bin/bash

set +x

. knative-deployment/ci/tasks/setup.sh

setup_kubectl

sleep 10

kubectl apply -f knative-deployment/service.yaml
