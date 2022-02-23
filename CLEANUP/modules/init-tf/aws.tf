terraform {
  required_version = "~> 0.14.10"
  required_providers {
    aws = {
    source = "hashicorp/aws"
    ##  Lock version to prevent unexpected problems
    version = "3.36"
    }
    null = {
    source = "hashicorp/null"
    version = "~> 3.1"
    }
    external = {
    source = "hashicorp/external"
    version = "~> 2.1"
    }
    kubernetes = {
    source = "hashicorp/kubernetes"
    version = "2.1.0"
    }
    
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.profile
}

provider "null" {}
provider "external" {}
