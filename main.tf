# these are computed values that are then used across the rest of the module
locals {
  should_publish         = var.docker_registry != ""
  # the type of jail selected will change the image built around the challenge
  jail_image_path        = "${path.module}/docker-images/${var.jail_type}"
  nsjail_image_path      = "${path.module}/docker-images/nsjail"
  healthcheck_image_path = "${path.module}/docker-images/healthcheck"

  # by tagging with the challenge sha1 hash, when a change is detected in the original challenge, it will force a redeployment
  chal_sha1        = sha1(join("", [for f in fileset(var.challenge_path, "**") : filesha1("${var.challenge_path}/${f}")]))
  healthcheck_sha1 = sha1(join("", concat([for f in fileset(local.healthcheck_image_path, "**") : filesha1("${local.healthcheck_image_path}/${f}")], [
    var.healthcheck ? filesha1("${var.challenge_path}/healthcheck.py") : "", sha1(var.healthcheck_additional_requirements)
  ])))

  published_healthcheck_image_name = local.should_publish ? "${var.docker_registry}/${var.name}_healthcheck:${local.healthcheck_sha1}" : "${var.name}_healthcheck:${local.healthcheck_sha1}"
  base_image_name                  = "${var.name}_base:${local.chal_sha1}"
  published_image_name             = local.should_publish ? "${var.docker_registry}/${var.name}:${local.chal_sha1}" : "${var.name}:${local.chal_sha1}"

  # tunnelling requires more capabilities to work properly
  k8s_capabilities = tomap({
    forking    = ["CHOWN", "MKNOD", "SETUID", "SETGID", "SYS_ADMIN", "SETFCAP"]
    tunnelling = ["CHOWN", "MKNOD", "SETUID", "SETGID", "DAC_OVERRIDE", "SYS_CHROOT", "FOWNER", "SYS_ADMIN", "SETFCAP"]
  })[
  var.jail_type
  ]
  # if port isn't set explicitly, forking uses port 1337, tunnelling exposes ssh for prolonged sessions
  k8s_port = coalesce(var.port, tomap({
    forking    = 1337
    tunnelling = 22
  })[
  var.jail_type
  ])
  # time limit default is 2 hours if tunnelling, otherwise it gets annoying
  time_limit = coalesce(var.time_limit, tomap({
    forking    = 600
    tunnelling = 7200
  })[
  var.jail_type
  ])
}