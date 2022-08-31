# terraform-kubernetes-ctf-chal

A [Terraform](https://registry.terraform.io/) module that allows
for a cloud-agnostic deployment of a dockerized CTF challenge
to a Kubernetes cluster. 

### features

As you can see, most of the features haven't been added yet.
Please hold.

- [x] namespace jailing
- [ ] optional resource restrictions
- [ ] autoscaling
- [ ] ingress configuration
- [ ] proof-of-work


### dependencies

* kubernetes - to authenticate with a cluster to deploy the challenge on
* docker - to build your challenge docker images on deployment and send them to a registry

Additionally, the kubernetes provider and the docker provider
must be authenticated to the same docker registry, as images pushed to the registry
will be subsequently pulled by kubernetes.

### usage

Here's a minimal configuration.

```terraform
module "challenge" {
   source = "KNOXDEV/ctf-chal/kubernetes"
   version = "1.0.1"
   name = "unique-challenge-name"
   challenge_path = "./path/to/challenge/source/code"
}
```

### challenge repo requirements

In order to be a valid target for the `challenge_path` input variable, a
git repository must meet the following requirements:

1. Contain a `Dockerfile` that builds your challenge in the root directory.
2. Expose the primary service on port `1337`.
3. Your `Dockerfile` must create a user with UID 1337, this will be the user that 
   nsjail is configured to use. `RUN /usr/sbin/useradd --no-create-home -u 1337 user`
4. Contain an `/home/user/entrypoint.sh` that launches your service. 
   Your `Dockerfile` does not necessarily need to call this, 
   but the `Dockerfile` that this module generates **will**.
5. **TODO**: Contain a `/home/user/healthcheck.sh` that returns true if the challenge is healthy,
   false otherwise.