terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.7.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.20.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
    google = {
      source = "hashicorp/google"
      version = "4.34.0"
    }
  }
}