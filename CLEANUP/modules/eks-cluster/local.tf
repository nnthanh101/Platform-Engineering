locals {
  cluster_name                  = var.eks_cluster_name
  asg_key_name                  = "${var.PROJECT_ID}-key"
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler"
}
