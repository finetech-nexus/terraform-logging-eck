provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube" # ou "docker-desktop", ou ton cluster local
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}