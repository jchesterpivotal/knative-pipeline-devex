#!/usr/bin/env bash

fly -t knative \
set-pipeline \
--pipeline $1 \
--config $1/pipeline.yml \
--var gke-cluster-address=https://35.188.101.33 \
--var gke-cluster-token=$(gcloud auth application-default print-access-token) \
--var app-image-repository=us.gcr.io/cf-elafros-dog/knative-devex-$1 \
--load-vars-from secrets.yaml

fly -t knative unpause-pipeline --pipeline $1