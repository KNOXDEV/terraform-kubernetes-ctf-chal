
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

When running the above, you will be prompted for some information, such as your GCP project ID.

Next, you'll need to switch to the `./k8s` directory to connect to the newly spun
up cluster and actually deploy an example challenge. This takes place in a separate
Terraform workspace because of limitations in how Terraform works; you'll need to
bring up the cluster before bringing up the deployments.

```bash
cd ./k8s
terraform init
terraform apply
```

**With permission**, I've borrowed a challenge from
[San Diego CTF 2022](https://github.com/acmucsd/sdctf-2022) and deployed it via
the `forking` jail type.

Connect to the challenge after deploying with the `service_ip` produced as output:

```bash
nc {service_ip} 1337
```