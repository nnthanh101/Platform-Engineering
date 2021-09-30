terraform {
  backend "s3" {
    region = var.region
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  cluster_name = var.eks_cluster_name
}

module "vpc" {
  ## https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  name    = var.vpc_name
  cidr    = var.vpc_cidr

  azs = slice(data.aws_availability_zones.available.names, 0, length(var.vpc_private_subnets))

  private_subnets      = var.vpc_private_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    tomap(
      { "VPCType" = var.vpc_type }
    )
  )

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

}

