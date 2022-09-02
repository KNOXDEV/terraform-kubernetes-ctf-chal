
# local cluster

This is an example of using `ctf-chal/kubernetes` in conjunction with the kubernetes cluster
that ships with Docker Desktop. This is a good way to run challenges locally before deploying
to a cloud provider.

## usage

In the configuration of Docker Desktop, you will need to enable the built-in
kubernetes cluster, as well as turn on connections to `tcp://localhost:2375`.
Both can be found in the settings.

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