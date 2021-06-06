# ---------------------------------------------------------------------------------------------------------------------
# Data lookup & manipulation
# ---------------------------------------------------------------------------------------------------------------------
# VPC data
data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"

    values = [
      "${var.vpc_name}",
    ]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Name"
    values = [
      "*private*"
    ]
  }
}

data "aws_partition" "current" {}

