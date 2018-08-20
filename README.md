# Knative Pipeline Devex Demo

This repo shows a simple example pipeline for going from a git commit to running Knative Service.

## Setting up the pipeline

Assuming you have a Concourse setup:

    fly -t knative-poc \
    set-pipeline \
    --pipeline devex \
    --config pipeline.yml \
    --var app-image-repository=us.gcr.io/$(gcloud config get-value project)/app-image \
    --var gke-cluster-token=$(gcloud auth application-default print-access-token)
    --var gke-cluster-address=YOUR-GKE-ADDRESS-HERE \
    --load-vars-from secrets.yaml

Replacing `YOUR-GKE-ADDRESS-HERE` with the cluster master. You can find it with `kubectl cluster-info`. I tried to do another magical subshell but the output is colourised.

The `gke-cluster-token` expires every few hours. I'm still not sure how to use a service account JSON key to drive `kubectl`.

### `secrets.yaml`

Not included in this repository, for what I hope are obvious reasons, is a `secrets.yaml` file. You will need to write one yourself. Unless your Concourse was configured with a credential store, in which case, use that.

You need to put these secrets into this file:

* `github-private-key`: This is the private key from an SSH keypair that you have added to your account.
* `gcp-service-account-json-key`: This is the JSON key used to identify a service account on your GCP Project.
* `gke-cluster-ca`: The cluster CA certificate. This is also in kubeconfig, but base64 encoded. You will need to decode it first.

Each time you edit `secrets.yaml`, you will need to run `fly set-pipeline` again.

If you check in a `secrets.yaml`, I accept no responsibility. I do however judge you. Don't do it.

### GCP accounts

I'm assuming GCP for everything here. GKE for Kubernetes, Google Container Registry, Google Cloud Storage.

You need to:

1. Set up a service account on GCP
1. Give that service account "Storage Admin" rights. You'd think narrower read/write permissions would work, but they didn't.
1. Create a GCS bucket. Be a good neighbour and give it a nice long name.

### Cleaning up

* Delete your `secrets.yaml`
* Destroy the service account.
