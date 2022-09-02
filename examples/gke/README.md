
# gke

This is an example of using `ctf-chal/kubernetes` in conjunction with
Google Cloud's Kubernetes Engine.

## usage

You'll need to install the following on your computer:

* terraform - for deploying and managing infrastructure
* docker    - for building and pushing containers
* gcloud    - for authenticating with Google Cloud's API

From there, authenticate with your GCP account and set your application default credentials:
```bash
gcloud auth login
gcloud auth application-default login
```

Then run Terraform to set up both the Google Kubernetes Engine cluster
and the Google Artifact Registry where docker images will be pushed.
This should take about 10-20 minutes, and you may be asked to enable
these APIs in your browser if this is a new project:

```bash
terraform init
terraform apply
```

**With permission**, I've borrowed a challenge from
[San Diego CTF 2022](https://github.com/acmucsd/sdctf-2022) and deployed it via
the `forking` jail type.

Connect to the challenge after deploying with:

```bash
nc localhost 1337
```