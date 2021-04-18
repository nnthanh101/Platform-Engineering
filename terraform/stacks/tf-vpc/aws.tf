terraform {
  required_version = "~> 0.14.10"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      ##  Allow any 3.36+  version of the AWS provider
      version = "~> 3.36"
    }
  }
}

provider "aws" {
  region                  = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}
