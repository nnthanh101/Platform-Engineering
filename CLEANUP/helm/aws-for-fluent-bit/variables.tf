variable "image_repo_url" {}
variable "image_repo_name" {
  default = "amazon/aws-for-fluent-bit"
}
variable "image_tag" {
  default = "2.12.0"
}
variable "cluster_id" {}
variable "ekslog_retention_in_days" {}

variable "public_docker_repo" {}