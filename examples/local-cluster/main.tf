// configuring kubernetes to use the Docker Desktop version
provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "docker-desktop"
}

provider "docker" {
  host = "tcp://localhost:2375"
}

module "ctf-chal-taap" {
  source = "../../"
  challenge_path = "./challenge"
  name = "kleptomanic"
  jail_type = "forking"
}