variable "org" {
  default = ""
}

variable "tenant" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "aws_account_id" {
  default = ""
}

variable "PROJECT_ID" {
  default = ""
}

variable "region" {
  default = "ap-southeast-1"
}

variable "origin_vpc_name" {
  default = "EKS-VPC"
}

variable "destination_vpc_name" {
  default = "CICD-VPC"
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}
