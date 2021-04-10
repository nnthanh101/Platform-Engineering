variable "PROJECT_ID" {
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
  type = list
  default = []
}

variable "vpc_public_subnets" {
  type = list
  default = []
}

variable "vpc_enable_nat_gateway" {
  default = true
}

variable "vpc_enable_vpn_gateway" {
  default = true
}

variable "vpc_single_nat_gateway" {
  default = true
}

variable "enable_s3_endpoint" {
  default = false
}

variable "eks_cluster_name" {
  default = "vpc"
}

# variable "terraform_modules_vpc_version" {
#   default = ""
# }

# variable "key_pair_public_key" {
#   default = ""
# }
