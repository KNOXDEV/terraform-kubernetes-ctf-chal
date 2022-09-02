data "google_container_engine_versions" "supported" {
  location       = var.zone
  version_prefix = var.kubernetes_version
}

# VPC for the cluster
resource "google_compute_network" "vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet for the cluster
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.cluster_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

// production GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = data.google_container_engine_versions.supported.latest_master_version
  # node version must match master version
  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#node_version
  node_version       = data.google_container_engine_versions.supported.latest_master_version

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # turn on Workload Identity, used by applications in the cluster to auth with GCP services
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # security hardening
  # https://cloud.google.com/kubernetes-engine/docs/how-to/shielded-gke-nodes
  enable_shielded_nodes = true
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name               = "${var.cluster_name}-node-pool"
  location           = var.zone
  cluster            = google_container_cluster.primary.name
  initial_node_count = var.min_node_count

  autoscaling {
    max_node_count = var.max_node_count
    min_node_count = var.min_node_count
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible = true
    machine_type = var.node_type
    metadata     = {
      disable-legacy-endpoints = "true"
    }
  }
}