variable "name" {
  type = string
  description = "name of the k8s deployment for this challenge"
}

variable "challenge_repo" {
  type = string
  description = "path to the challenge repo, which needs to be structured correctly"
}

variable "domain" {
  type = string
  nullable = true
  description = "the domain to point at this challenge"
}

variable "ingress" {
  type = bool
  description = "if true, creates an ingress to allow external connections on a particular domain"
  default = false
}


variable "healthcheck_path" {
  type = string
  description = "path to the healthcheck script which checks if the deployment needs to be replaced"
  default = "healthcheck.sh"
}

variable "jail" {
  type = object({
    mount_path = string
  })
  description = "the configuration for the nsjail to apply, defaults to null (not enabled)"
  default = null
}