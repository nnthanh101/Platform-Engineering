variable "PROJECT_ID" {
  default = ""
}

variable "org" {
  default = ""
}

variable "tenant" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "region" {
  default = "ap-southeast-1"
}

variable "vpc_name" {
  default = ""
}

variable "vpc_cidr" {
  default = ""
}

variable "vpc_private_subnets" {
  type    = list(any)
  default = []
}

variable "vpc_enable_nat_gateway" {
  default = true
}

variable "vpc_enable_vpn_gateway" {
  default = true
}

variable "vpc_single_nat_gateway" {
  default = false
}

variable "enable_s3_endpoint" {
  default = false
}

variable "vpc_type" {
  default = ""
}

# variable "key_pair_public_key" {
#   default = ""
# }


variable "eks_cluster_name" {
  default = ""
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}
