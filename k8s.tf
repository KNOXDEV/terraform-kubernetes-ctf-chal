# lets create a namespace for our ctf challenges
resource "kubernetes_namespace" "challenge_ns" {
  metadata {
    name = "ctf-chals"
  }
}

resource "kubernetes_deployment" "challenge_deployment" {
  depends_on = [docker_registry_image.challenge_published, docker_image.chal]
  metadata {
    name      = "${var.name}-deploy"
    namespace = kubernetes_namespace.challenge_ns.metadata[0].name
    labels    = {
      app = var.name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.name
        }
        # required to mount things in most clouds
        annotations = {
          "container.apparmor.security.beta.kubernetes.io/challenge" : "unconfined"
        }
      }
      spec {
        container {
          name  = "challenge"
          image = local.published_image_name
          port {
            container_port = 1337
          }
          image_pull_policy = "Always"
          # this is the most restrictive context that still allows nsjail to run
          security_context {
            read_only_root_filesystem = true
            capabilities {
              drop = ["ALL"]
              add  = local.k8s_capabilities
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "challenge_service" {
  depends_on = [kubernetes_deployment.challenge_deployment, docker_image.chal]
  metadata {
    name      = "${var.name}-service"
    namespace = kubernetes_namespace.challenge_ns.metadata[0].name
    labels    = {
      app = var.name
    }
  }
  spec {
    type = "LoadBalancer"
    port {
      port        = local.k8s_port
      protocol    = "TCP"
      target_port = 1337
    }
    selector = {
      app = var.name
    }
  }
}