terraform {
  backend "s3" {
    region = var.region 
  }
}

provider "aws" {
  region  = var.region
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

  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = var.vpc_enable_nat_gateway
  #  enable_vpn_gateway   = var.vpc_enable_vpn_gateway
  single_nat_gateway   = var.vpc_single_nat_gateway

  enable_s3_endpoint   = var.enable_s3_endpoint

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
