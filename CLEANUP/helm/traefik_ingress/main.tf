locals {
  image_url = var.public_docker_repo ? var.image_repo_name : "${var.image_repo_url}${var.image_repo_name}"
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "9.18.1"
  namespace  = "kube-system"
  timeout    = "1200"

  values = [templatefile("${path.module}/traefik_values.yaml", {
    image     = local.image_url
    tag       = var.image_tag
    s3_bucket = var.s3_nlb_logs
    replicas  = 3
  })]

}
