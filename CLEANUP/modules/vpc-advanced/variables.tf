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

variable "vpc_type" {
  default = ""
}

variable "vpc_cidr" {
  default = ""
}

variable "vpc_private_subnets" {
  type    = list(any)
  default = []
}

variable "vpc_public_subnets" {
  type    = list(any)
  default = []
}

variable "vpc_database_subnets" {
  type    = list(any)
  default = []
}

variable "vpc_elasticache_subnets" {
  type    = list(any)
  default = []
}

variable "vpc_create_db_subnet_route_table" {
  default = true
}

variable "vpc_create_escache_subnet_route_table" {
  default = true
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

# Variables for vpc endpoint S3
variable "enable_s3_endpoint" {
  default = true
}

variable "s3_endpoint_type" {
  default = "Interface"
}

# Variables for vpc flow log 
variable "vpc_enable_flow_log" {
  default = true
}

variable "vpc_flow_log_destination" {
  default = "s3"
}

variable "vpc_fl_create_cloudwatch_log_group" {
  default = true
}

variable "vpc_fl_create_cloudwatch_iam_role" {
  default = true
}

variable "vpc_fl_max_agg_interval" {
  default = 60
}

variable "eks_cluster_name" {
  default = ""
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}
