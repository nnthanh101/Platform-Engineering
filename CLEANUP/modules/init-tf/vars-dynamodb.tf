variable "table_name_vpc_networking" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-vpc-networking"
}

variable "table_name_iam" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-iam"
}

variable "table_name_vpc_peering" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-vpc-peering"
}

variable "table_name_eks_cicd" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-eks-cicd"
}

variable "table_name_eks_cluster" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-eks-cluster"
}

variable "table_name_nodegroup" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-nodegroup"
}

variable "table_name_vpc_networking_adv" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "vpc-networking-adv"
}

variable "table_name_k8s_apps" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-k8s-apps"
}
