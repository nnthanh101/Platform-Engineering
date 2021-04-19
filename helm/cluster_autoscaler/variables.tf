variable "image_repo_url" {}
variable "image_repo_name" {
  default = "k8s.gcr.io/autoscaling/cluster-autoscaler"
}
variable "image_tag" {
  default = "v1.19.1"
}
variable "eks_cluster_id" {
  description = "EKS_Cluster_ID"
}

variable "public_docker_repo" {}