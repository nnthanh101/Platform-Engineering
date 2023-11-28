locals {
  image_url = var.public_docker_repo ? var.image_repo_name : "${var.image_repo_url}${var.image_repo_name}"
}

resource "aws_cloudwatch_log_group" "eks-worker-logs" {
  name              = "/aws/eks/${var.cluster_id}/fluentbit-cloudwatch-logs"
  retention_in_days = var.ekslog_retention_in_days
}

resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"
  }
}

resource "helm_release" "aws-for-fluent-bit" {
  name       = "aws-for-fluent-bit"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  version    = "0.1.7"
  namespace  = kubernetes_namespace.logging.id
  timeout    = "1200"
  values = [templatefile("${path.module}/templates/aws-for-fluent-bit-values.yaml", {
    image              = local.image_url
    tag                = var.image_tag
    cw_worker_loggroup = aws_cloudwatch_log_group.eks-worker-logs.name
  })]
}

