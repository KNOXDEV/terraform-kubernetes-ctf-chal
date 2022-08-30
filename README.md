# terraform-kubernetes-ctf-chal

A [Terraform](https://registry.terraform.io/) module that allows
for a cloud-agnostic deployment of a dockerized CTF challenge
to a Kubernetes cluster. 

### features

As you can see, most of the features haven't been added yet.
Please hold.

- [ ] optional resource restrictions
- [ ] namespace jailing
- [ ] autoscaling
- [ ] ingress configuration
- [ ] proof-of-work


### dependencies

* kubernetes - to authenticate with a cluster to deploy the challenge on
* docker - to build your challenge docker images on deployment and send them to a registry
* cloudflare (optional) - to automatically configure dns

### usage

```bash
terraform apply
```

### challenge repo requirements

In order to be a valid target for the `challenge_repo` input variable, a
git repository must meet the following requirements:

1. Contain a `Dockerfile` that builds your challenge in the root directory.
2. Expose the primary service on port `1337`.
3. Contain an `entrypoint.sh` that launches your service. 
   Your `Dockerfile` does not necessarily need to call this, 
   but the Dockerfile that this module generates **will**.
4. Contain a `healthcheck.sh` that returns true if the challenge is healthy,
   false otherwise.