## TF_VAR_region
variable "region" {
  description = "The name of the AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "profile" {
  description = "The name of the AWS profile in the credentials file"
  type        = string
  default     = "default"
}

variable "cluster-name" {
  description = "The name of the EKS Cluster"
  type        = string
  default     = "eks-cluster"
}

variable "stages" {
  type=list(string)
  default=["vpc-networking","iam","vpc-peering","eks-cluster","nodegroup","eks-cicd","vpc-networking-adv","k8s-apps"]
}

variable "stagecount" {
  type=number
  default=8
}
