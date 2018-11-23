#!/bin/bash


echo $CONFIG > key.json

gcloud auth activate-service-account --key-file=key.json

gcloud container clusters get-credentials $CLUSTER_NAME --zone=us-east1-b

kubectl version


