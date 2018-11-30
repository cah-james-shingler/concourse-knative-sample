#!/bin/bash

. knative-test/ci/tasks/setup.sh

setup_kubectl

echo "Deleting build $BUILD_NAME"

kubectl delete build $BUILD_NAME
