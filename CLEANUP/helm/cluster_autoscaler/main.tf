locals {
  image_url = var.public_docker_repo ? var.image_repo_name : "${var.image_repo_url}${var.image_repo_name}"
}

resource "helm_release" "autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.9.2"
  namespace  = "kube-system"
  timeout    = "1200"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_cluster_id
  }

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "extraArgs.aws-use-static-instance-list"
    value = "true"
  }
  set {
    name  = "awsRegion"
    value = "ap-southeast-1"
  }
  set {
    name  = "image.repository"
    value = local.image_url
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }
}
