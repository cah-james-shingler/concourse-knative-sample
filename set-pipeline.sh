#!/bin/bash

lpass sync

fly -t wings sp -p knative -c ci/pipeline.yml \
  -v "key=$(lpass show --notes 'Cluster Key')" \
  -v "cluster=knative-test" \
  -v "project=lively-sentry-221201" \
  -v "zone=us-east1-b" \
  -v "docker-username=$(lpass show --username Docker)" \
  -v "docker-password=$(lpass show --password Docker)"
