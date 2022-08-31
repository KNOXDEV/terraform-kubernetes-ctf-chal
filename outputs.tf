output "service_ip" {
  value = kubernetes_service.challenge_service.status[0].load_balancer[0].ingress[0].ip
  description = "service ip your challenge should be available at"
}