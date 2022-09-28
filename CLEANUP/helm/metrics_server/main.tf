locals {
  image_url = var.public_docker_repo ? var.image_repo_name : "${var.image_repo_url}${var.image_repo_name}"
}

resource "helm_release" "metric_server" {
  name       = "metric-server"
  repository = "https://charts.appuio.ch"
  chart      = "metrics-server"
  version    = "2.12.0"
  namespace  = "kube-system"
  timeout    = "1200"

  set {
    name  = "replicas"
    value = 3
  }

  set {
    name  = "image.repository"
    value = local.image_url
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
}
