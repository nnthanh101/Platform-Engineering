terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.37.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.1"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
  alias  = "default"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
}
