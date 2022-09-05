variable "name" {
  type        = string
  description = "name of the k8s deployment for this challenge"
}

variable "challenge_path" {
  type        = string
  description = "path to the challenge source code, which must contain a Dockerfile"
}

variable "docker_registry" {
  type        = string
  description = "the docker registry to push images to (kubernetes must also have access to this)"
  default     = ""
}

variable "jail_type" {
  type        = string
  description = "the type of jail that will be used for this challenge (see README)"
  default     = "forking"
}

variable "port" {
  type        = string
  description = "external k8s port to expose for the service (default: 22 for tunnelling, 1337 otherwise)"
  default     = null
}

variable "time_limit" {
  type        = number
  description = "number of wall seconds the connection may stay open (default: 2 hours for tunnelling, 10 minutes otherwise)"
  default     = null
}

variable "memory_limit" {
  type        = number
  description = "number of MB of memory the connection may consume (default: 1024)"
  default = 1024
}

variable "pid_limit" {
  type        = number
  description = "number of processes the connection may open (default: 5)"
  default     = 5
}

variable "min_replicas" {
  type = number
  description = "the minimum number of pod replicas to spin up for this challenge"
  default = 1
}

variable "max_replicas" {
  type = number
  description = "the maximum number of pod replicas to spin up for this challenge"
  default = 1
}

variable "target_utilization" {
  type = number
  description = "cpu utilization percentage to target for horizontal pod autoscaling"
  default = 60
}