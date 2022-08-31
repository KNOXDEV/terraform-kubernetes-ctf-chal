variable "name" {
  type = string
  description = "name of the k8s deployment for this challenge"
}

variable "challenge_path" {
  type = string
  description = "path to the challenge source code, which must contain a Dockerfile"
}

variable "docker_registry" {
  type = string
  description = "the docker registry to push images to (kubernetes must also have access to this)"
  default = ""
}