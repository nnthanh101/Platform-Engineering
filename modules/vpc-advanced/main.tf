terraform {
  backend "s3" {
    region = var.region 
  }
}

provider "aws" {
  region   = var.region
}

data "aws_security_group" "default" {
  name     = "default"
  vpc_id   = module.vpc.vpc_id
}

locals {
  flow_log_to_s3            = var.vpc_flow_log_destination == "s3"
  s3_bucket_name            = "vpc-flow-logs-to-s3-${random_pet.this.id}"
  cloudwatch_log_group_name = "vpc-flow-logs-to-cloudwatch-${random_pet.this.id}"
}

resource "random_pet" "this" {
  length = 2
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  ## https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"
  name    = var.vpc_name
  cidr    = var.vpc_cidr

  azs = slice(data.aws_availability_zones.available.names, 0, length(var.vpc_public_subnets))

  ## Subnets 
  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  database_subnets     = var.vpc_database_subnets
  elasticache_subnets  = var.vpc_elasticache_subnets

  create_database_subnet_route_table    = var.vpc_create_db_subnet_route_table
  create_elasticache_subnet_route_table = var.vpc_create_escache_subnet_route_table

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = var.vpc_enable_nat_gateway
  single_nat_gateway   = var.vpc_single_nat_gateway

  ## VPC Endpoint for S3
  enable_s3_endpoint   = var.enable_s3_endpoint
  s3_endpoint_type     = var.s3_endpoint_type
  s3_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  ## VPC Flow Logs 
  enable_flow_log                     = var.vpc_enable_flow_log
  flow_log_max_aggregation_interval   = var.vpc_fl_max_agg_interval
  flow_log_destination_type           = var.vpc_flow_log_destination
  flow_log_destination_arn            = local.flow_log_to_s3 ? module.s3_bucket[0].this_s3_bucket_arn : aws_cloudwatch_log_group.flow_log[0].arn
  
  flow_log_cloudwatch_iam_role_arn    = local.flow_log_to_s3 ? "" : aws_iam_role.vpc_flow_log_cloudwatch[0].arn

  tags = {
    ProjectID   = var.PROJECT_ID
    org         = var.org
    tenant      = var.tenant
    environment = var.environment
    VPCType     = var.vpc_type
  }

  vpc_endpoint_tags = {
    Endpoint  = "true"
  }
}
