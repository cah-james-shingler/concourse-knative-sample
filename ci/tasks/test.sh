#!/bin/bash

gcloud auth activate-service-account kubectl --key-file=$CONFIG

gcloud container clusters knative-test --zone=us-east1-b

kubectl version


