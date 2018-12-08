#!/bin/bash

lpass sync

fly -t sample sp -p knative -c ci/pipeline.yml \
  -v "key=$(lpass show --notes 'Cluster Key')" \
  -v "cluster=knative-test" \
  -v "project=lively-sentry-221201" \
  -v "zone=us-east1-b"
