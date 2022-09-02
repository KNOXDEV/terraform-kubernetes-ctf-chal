# should pull specific auth from local gcloud cli
provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}