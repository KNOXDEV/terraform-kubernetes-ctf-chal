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
    path      = local.jail_image_path
    build_arg = {
      CHALLENGE_IMAGE = local.base_image_name
      MEM_LIMIT = var.memory_limit * 1024 * 1024 // config is in MB, cgroups expects bytes...
      CPU_LIMIT = var.time_limit
      PID_LIMIT = var.pid_limit
    }
    tag = ["${var.name}:latest", local.published_image_name]
  }
  # mainly for development of the module, if the jail sourcecode changes, rebuild
  triggers = {
    sha1 = sha1(join("", [for f in fileset(local.jail_image_path, "**") : filesha1("${local.jail_image_path}/${f}")]))
  }
}

# publish the docker image to the provided registry ONLY IF one was given
resource "docker_registry_image" "challenge_published" {
  count      = local.should_publish ? 1 : 0
  depends_on = [docker_image.chal]
  name       = local.published_image_name
}