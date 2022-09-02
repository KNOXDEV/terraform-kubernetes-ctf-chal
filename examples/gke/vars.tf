variable "project_id" {
  description = "the ID of the GCP project"
}

variable "region" {
  type = string
  description = "the region to perform operations in if possible"
  default = "us-west1"
}

variable "zone" {
  type = string
  description = "the zone in the above region to perform operations in if possible"
  default = "us-west1-c"
}

variable "kubernetes_version" {
  type = string
  default = "1.25"
}

# see node types here https://cloud.google.com/compute/docs/general-purpose-machines
variable "node_type" {
  type = string
  description = "the type of GCP compute instance to deploy as k8s nodes"
  default = "e2-standard-2"
}

variable "max_node_count" {
  type = number
  description = "the number of nodes AT MOST to allocate in the cluster"
  default = 10
}

variable "min_node_count" {
  type = number
  description = "the number of nodes AT LEAST to allocate in the cluster"
  default = 2
}

variable "cluster_name" {
  type = string
  description = "the name to give the GKE cluster"
}

variable "artifact_repository_id" {
  type = string
  description = "the name to give the Google Cloud Artifact Registry instance"
}