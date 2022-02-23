# data "aws_eks_cluster" "cluster" {
#   name = var.eks_cluster_name
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = var.eks_cluster_name
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

# resource "kubernetes_csi_driver" "this" {
#   metadata {
#     name = lower("${var.PROJECT_ID}-sci-driver")
#   }

#   spec {
#     attach_required        = true
#     pod_info_on_mount      = true
#     volume_lifecycle_modes = ["Persistent"]
#   }
# }

# resource "kubernetes_storage_class" "this" {
#   metadata {
#     name = lower("${var.PROJECT_ID}-sc")
#   }
#   storage_provisioner = "efs.csi.aws.com"
#   reclaim_policy      = "Retain"

# }

