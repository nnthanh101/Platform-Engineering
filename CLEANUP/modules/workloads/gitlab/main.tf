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

resource "helm_release" "gitlab" {
  count            = var.enabled ? 1 : 0
  chart            = var.helm_chart_name
  namespace        = var.k8s_namespace
  name             = var.helm_release_name
  version          = var.helm_chart_version
  repository       = var.helm_repo_url
  create_namespace = true

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.ingress_annotations
    content {
      name  = "ingress.annotations.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.minio.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.webservice.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.gitaly.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.sidekiq.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.taskRunner.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.gitlabShell.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.migrations.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlab.gitlabExplorer.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "redis.master.nodeSelector.${set.key}"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "postgresql.master.nodeSelector.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.node_selector

    content {
      name  = "gitlabRunner.nodeSelector.${set.key}"
      value = set.value
    }
  }
}
