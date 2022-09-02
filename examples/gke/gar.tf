# artifact registry to store challenge images
resource "google_artifact_registry_repository" "repository" {
  location      = var.region
  format        = "DOCKER"
  repository_id = var.artifact_repository_id
}
