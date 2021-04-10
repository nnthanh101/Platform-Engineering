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

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
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
    ProjectID                                       = var.PROJECT_ID
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

# resource "aws_key_pair" "key-pair" {
#   key_name   = "${var.PROJECT_ID}-key"
#   public_key = var.key_pair_public_key
# }
