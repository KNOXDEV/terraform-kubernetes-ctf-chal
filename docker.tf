# build the base challenge image
resource "docker_image" "challenge_base" {
  name = "challenge-base-image"
  build {
    path = var.challenge_path
    tag  = [local.base_image_name]
  }
}

# generate a chal / jail base image that will be cached and reused between the modules
resource "docker_image" "nsjail" {
  name = "nsjail-image"
  build {
    path      = "${path.module}/docker-images/nsjail"
    build_arg = {
      NSJAIL_RELEASE = "3.1"
    }
    tag = ["nsjail:latest"]
  }
}

# generate the jailed docker image
resource "docker_image" "chal" {
  depends_on = [docker_image.nsjail, docker_image.challenge_base]
  name       = "challenge-jailed-image"
  build {
    path      = "${path.module}/docker-images/forking"
    build_arg = {
      CHALLENGE_IMAGE = local.base_image_name
    }
    tag = ["${var.name}:latest", local.published_image_name]
  }
}

# publish the docker image to the provided registry ONLY IF one was given
resource "docker_registry_image" "challenge_published" {
  count      = local.should_publish ? 1 : 0
  depends_on = [docker_image.chal]
  name       = local.published_image_name
}