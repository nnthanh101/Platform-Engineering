terraform {
  backend "s3" {
    region = var.region
  }
}

provider "aws" {
  region = var.region
}

### EKS
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "metrics_server" {
  count            = var.enabled ? 1 : 0
  chart            = var.helm_chart_name
  namespace        = var.k8s_namespace
  name             = var.helm_release_name
  version          = var.helm_chart_version
  repository       = var.helm_repo_url
  create_namespace = true

  set {
    name  = "apiService.create"
    value = true
  }

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.extra_args
    content {
      name  = "extraArgs.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "nodeSelector.${set.key}"
      value = set.value
    }
  }
}
