#!/bin/bash


echo $CONFIG > key.json

gcloud auth activate-service-account --key-file=key.json

gcloud container clusters knative-test --zone=us-east1-b

kubectl version


