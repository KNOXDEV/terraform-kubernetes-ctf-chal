# ctf-chal/kubernetes

A [Terraform](https://registry.terraform.io/) module that allows
for a cloud-agnostic deployment of a dockerized CTF challenge
to a Kubernetes cluster.

### usage

1. Write a CTF challenge as a Dockerized application exposing the service on port 1337.
2. Create a Terraform repo that connects to a Kubernetes cluster you want to deploy to.
3. Use the below minimal configuration to deploy your challenge.

```terraform
module "challenge" {
   source = "KNOXDEV/ctf-chal/kubernetes"
   version = "1.2.0"
   name = "unique-challenge-name"
   challenge_path = "./path/to/challenge/source/code"
   jail_type = "forking"
}
```

For free, you'll get all the features described in the next section.

### features

Most of the features of a complete production-quality jail have been implemented.

- [x] process and player isolation (via [nsjail](https://github.com/google/nsjail))
- [x] sandbox filesystems (via ssh tunnelling)
- [x] hardware resource restrictions
- [x] autoscaling to meet fluctuating demand
- [x] healthchecks (catch pod degradation)
- [ ] efficient (shared) ingress management
- [ ] proof-of-work (prevent DoS)

### jail types

Currently, there are **two types** of jails you can use.

#### forking

The default type, `forking`, will listen to incoming connections on port 1337 and for each,
create an isolated namespace for your challenge process to execute in.

Challenges of this type will generally be connected to like so:
```bash
nc domain.example.com 1337
```

This type is well suited to most challenges that require process jailing, including:
* pwnable binaries
* actual escape-the-jail challenges
* local file inclusions

#### tunnelling

The more complicated type, `tunnelling`, will create an ssh server that will allow
players to forward a challenge service to a local port on their system. 
The primary benefit of this approach is that the challenge filesystem can transparently
store isolated state for the length of the ssh connection, independent of the type or number
of service requests. This is especially useful for web challenges that require state,
as each HTTP request would reset the challenge if it were jailed via the `forking` method.


Challenges of this type will generally be connected to like so:
```bash
ssh -N -L 8000:127.0.0.1:1337 user@domain.example.com
```

This will create a new service accessible from the challenger's `localhost:8000`
that is connected to the deployment cluster. The player can terminate this connection
and reconnect to get a fresh filesystem.

This type is well suited to most challenges that requires state between connections, including:
* web services
* any challenge that needs file system writes to solve

Use of the `tunnelling` jail type *is* subject to some
[additional requirements](#challenge-image-assumptions) on the challenge image.


### provider dependencies

There are two major terraform providers you must already have configured when including this module:

* [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) -
to authenticate with a cluster to deploy the challenge on
* [docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs) -
to build your challenge docker images on deployment and send them to a registry

Additionally, the kubernetes provider and the docker provider
must be authenticated to the same docker registry, as images pushed to the registry
will be subsequently pulled by kubernetes.

### challenge image assumptions

One of the primary goals of this module is to separate the concerns of 
challenge development and deployment as much as possible. As such,
the number of assumptions made about the structure of a challenge's docker image
is kept to a minimum.

In order to be a valid target for the `challenge_path` input variable, a
challenge directory must meet the following requirements:

1. Contain a `Dockerfile` that builds your challenge.
2. Expose the primary service on port `1337`.
3. Your `Dockerfile` must create a user and group with UID `1337`, this will be the user that 
   nsjail is configured to use. `RUN /usr/sbin/useradd --no-create-home -u 1337 user`
4. Contain an `/home/user/entrypoint.sh` that launches your service. 
   Your `Dockerfile` does not necessarily need to call this, 
   but the `Dockerfile` that this module generates **will**.
5. **TODO/WIP**: Contain a `/home/user/healthcheck.sh` that returns true if the challenge is healthy,
   false otherwise.

The `tunnelling` jail type has the following **additional requirements**:

1. The challenge image is built on top of an ubuntu base image.
2. The challenge image does not bind to port 2022 (used for ssh).
3. Your challenge is not effected by a running sshd daemon.

These requirements are due to the fact that the tunnelling jail
needs to install additional runtime dependencies, mainly `socat` and `sshd`,
in order to provide port forwarding.

### healthcheck assumptions

In order to take advantage of the healthcheck functionalities,
you need to feed the module a python script via the
input variable `healthcheck_path`.

This script will be called every 30 seconds or so.
If this script returns a non-zero exit code,
the challenge container will be restarted. 
Ideally, this script should solve your challenge and make
sure the flag is still obtainable via the intended method.
If at any point, the challenge degrades and is no longer solvable,
k8s will catch this and restart your container.

Your healthcheck script can access the service on `localhost:1337`,
and by default, you will have access to `pwntools`.
You can install any additional healthcheck dependencies with the
`healthcheck_additional_requirements` input variable.

Writing a healthcheck for every challenge is not always feasible,
but is generally recommended.


## acknowledgements

The work this module does would be impossible without building on the backs of these
incredible projects:

1. [Google's kCTF](https://github.com/google/kctf)
2. [redpwn's jail](https://github.com/redpwn/jail)