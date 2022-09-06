// configuring kubernetes to use the Docker Desktop version
provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "docker-desktop"
}

provider "docker" {
  host = "tcp://localhost:2375"
}

module "ctf-chal" {
  source = "../../"
  challenge_path = "./challenge"
  name = "unique-lasso"
  healthcheck = true
  jail_type = "forking"
}