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
  }
}