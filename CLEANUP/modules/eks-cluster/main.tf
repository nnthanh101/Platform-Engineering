terraform {
  backend "s3" {
    region = var.region
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode("${data.aws_eks_cluster.cluster.certificate_authority.0.data}")
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnets         = data.aws_subnet_ids.all.ids
  vpc_id          = data.aws_vpc.vpc.id
  enable_irsa     = true

  cluster_endpoint_private_access = true

  node_groups = {
    # spot_private = {
    #   desired_capacity = var.node_spot_private_desired_size
    #   max_capacity     = var.node_spot_private_max_size
    #   min_capacity     = var.node_spot_private_min_size

    #   capacity_type  = "SPOT"
    #   instance_types = [var.instance_type_Spot]

    #   k8s_labels = {
    #     SubnetType    = var.NODE_SELECTOR_PRIVATE
    #     NodeGroupType = var.NODE_SELECTOR_MANAGED_NODE_GROUP
    #     NodeLifeCycle = var.NODE_SELECTOR_SPOT
    #     InstanceType  = "x86"
    #   }
    # }
    ondemand_private = {
      desired_capacity = var.node_private_desired_size
      max_capacity     = var.node_private_max_size
      min_capacity     = var.node_private_min_size

      instance_types = [var.instance_type_AMD]

      k8s_labels = {
        SubnetType    = var.NODE_SELECTOR_PRIVATE
        NodeGroupType = var.NODE_SELECTOR_MANAGED_NODE_GROUP
        NodeLifeCycle = "ON_DEMAND"
        InstanceType  = "x86"
      }
    }
    # graviton2 = {
    #   desired_capacity = var.node_private_desired_size
    #   max_capacity     = var.node_private_max_size
    #   min_capacity     = var.node_private_min_size

    #   instance_types = [var.instance_type_Graviton2]
    #   ami_type       = "AL2_ARM_64" # AL2_x86_64 AL2_x86_64_GPU AL2_ARM_64 CUSTOM

    #   k8s_labels = {
    #     SubnetType    = var.NODE_SELECTOR_PRIVATE
    #     NodeGroupType = var.NODE_SELECTOR_MANAGED_NODE_GROUP
    #     NodeLifeCycle = var.NODE_SELECTOR_NORMAL
    #     InstanceType  = "arm64"
    #   }
    # }
  }
  map_users = var.map_users
  map_roles = var.map_roles

  tags = var.tags
}

