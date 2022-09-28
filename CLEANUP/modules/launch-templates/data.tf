
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}