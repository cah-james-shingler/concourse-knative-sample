#!/bin/bash

. knative-test/ci/tasks/setup.sh

setup_kubectl

kubectl delete build kaniko-build
