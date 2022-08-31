# service ip your challenge is available at
output "service_ip" {
  value = kubernetes_service.challenge_service.status[0].load_balancer[0].ingress[0].ip
}