variable "image_repo_url" {}
variable "image_repo_name" {
  default = "traefik"
}

variable "image_tag" {
  default = "v2.4.8"
}

variable "s3_nlb_logs" {}

variable "account_id" {}

//variable "tls_cert_arn" {}
variable "public_docker_repo" {}
