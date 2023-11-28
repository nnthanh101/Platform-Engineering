variable "public_docker_repo" {}
variable "image_repo_url" {}
variable "image_repo_name" {
  default = "amazon/aws-load-balancer-controller"
}

variable "image_tag" {
  default = "v2.1.3"
}

variable "replicas" {
  default = "2"
}

variable "clusterName" {}

variable "eks_oidc_provider_arn" {}

variable "eks_oidc_issuer_url" {}