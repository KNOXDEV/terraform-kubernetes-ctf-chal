locals {
  service_ip = kubernetes_service.challenge_service.status[0].load_balancer[0].ingress[0].ip
}

output "service_ip" {
  value = local.service_ip
  description = "service ip your challenge should be available at"
}

output "connection_string" {
  value = tomap({
    forking = "nc ${local.service_ip} 1337",
    tunnelling = "ssh -N -L 8000:127.0.0.1:1337 user@${local.service_ip}"
  })[var.jail_type]
}