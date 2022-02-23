variable "cluster_auth_base64" {
}
variable "cluster_endpoint" {
}
variable "cluster_name" {
}
variable "node_group_name" {}
//variable "instance_type" {}
variable "volume_size" {
  default = "50"
}
variable "tags" {}
variable "worker_security_group_id" {}
variable "bottlerocket_ami" {
  type        = string
  default     = "ami-003218f70ab99148c"
  description = "/aws/service/bottlerocket/aws-k8s-1.19/x86_64/latest/image_id"
}
variable "self_managed" {
  default = false
}