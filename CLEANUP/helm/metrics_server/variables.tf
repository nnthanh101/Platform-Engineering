variable "image_repo_url" {}
variable "image_repo_name" {
  default = "k8s.gcr.io/metrics-server/metrics-server"
}
variable "image_tag" {
  default = "v0.4.2"
}
variable "public_docker_repo" {}