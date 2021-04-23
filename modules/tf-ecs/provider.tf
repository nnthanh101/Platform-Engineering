# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER FOR TF CLOUD
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.14"
}


provider "aws" {
  version = "~> 3.36"
  region  = var.aws_region
  profile = var.aws_profile
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER USING TF CLI
# ---------------------------------------------------------------------------------------------------------------------

# provider "aws" {
#   profile = "default-ecs"
#   version = "~> 3.36"
#   region  = "${var.aws_region}"
# }

# terraform {
#   required_version = "~> 0.14"
#   backend "remote" {
#     organization = "aws-isv"

#     workspaces {
#       name = "petclinic-fargate"
#     }
#   }
# }