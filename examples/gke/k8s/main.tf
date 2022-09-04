# should pull specific auth from local gcloud cli
provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}

# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

# read the cluster data
data "google_container_cluster" "default" {
  name = var.cluster_name
}

// configuring our different k8s providers using the gcloud credentials
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.default.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}

# we can reuse this access token to push images to docker
provider "docker" {
  host = "tcp://localhost:2375"
  registry_auth {
    address = "${var.region}-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}


module "challenge" {
  # this keeps us from deploying challenges before the GCP stuff is initialized
  depends_on = [data.google_container_cluster.default]
  source = "../../../"
  challenge_path = "./challenge"
  name = "kleptomanic"
  docker_registry = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repository_id}"
}

output "service_ip" {
  value = module.challenge.service_ip
}