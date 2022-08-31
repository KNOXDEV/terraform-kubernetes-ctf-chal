locals {
  should_publish       = var.docker_registry != ""
  # by tagging with the challenge sha1 hash, when a change is detected in the original challenge, it will force a redeployment
  chal_sha1            = sha1(join("", [for f in fileset(var.challenge_path, "**") : filesha1("${var.challenge_path}/${f}")]))
  base_image_name      = "${var.name}_base:${local.chal_sha1}"
  published_image_name = local.should_publish ? "${var.docker_registry}/${var.name}:${local.chal_sha1}" : "${var.name}:${local.chal_sha1}"
}