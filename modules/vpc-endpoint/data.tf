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

data "aws_route_tables" "rtb" {
  vpc_id = data.aws_vpc.vpc.id
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

# AWS Parameter Store lookup
# data "aws_ssm_parameter" "vpc_private_subnet_ids" {
#   provider = aws.parameter_store_account
#   count    = length(var.path_to_vpc_private_subnet_ids)
#   name     = var.path_to_vpc_private_subnet_ids
# }

# data "aws_ssm_parameter" "vpc_private_route_table_ids" {
#   provider = aws.parameter_store_account
#   count    = length(var.path_to_vpc_private_route_table_ids)
#   name     = var.path_to_vpc_private_route_table_ids
# }

# data "aws_subnet" "selected" {
#   count = var.create_vpc_endpoints && var.path_to_vpc_private_subnet_ids != "" ? 1 : 0

#   id = split(",", data.aws_ssm_parameter.vpc_private_subnet_ids[0].value)[0]
# }

data "aws_vpc_endpoint_service" "gateway" {
  for_each = toset(var.create_vpc_endpoints ? var.vpc_endpoint_services_gateway : [])

  // If we get a "common name" (like "kms") we must generate a fully qualified name.
  // If the name contains the current region we trust the user to have provided a valid fully qualified name.
  // This handles all _current_ services.
  // * Simple ones like "s3" or "sns".
  // * Complex common names like "ecr.dkr" and "ecr.api".
  // * Non-standard services like sagemeaker where the fully qualified name is like "aws.sagemaker.us-east-1.notebook".
  service_name = length(regexall(var.region, each.key)) == 1 ? each.key : "com.amazonaws.${var.region}.${each.key}"
  service_type = "Gateway"
}

data "aws_vpc_endpoint_service" "interface" {
  for_each = toset(var.create_vpc_endpoints ? var.vpc_endpoint_services_interface : [])

  // If we get a "common name" (like "kms") we must generate a fully qualified name.
  // If the name contains the current region we trust the user to have provided a valid fully qualified name.
  // This handles all _current_ services.
  // * Simple ones like "s3" or "sns".
  // * Complex common names like "ecr.dkr" and "ecr.api".
  // * Non-standard services like sagemeaker where the fully qualified name is like "aws.sagemaker.us-east-1.notebook".
  service_name = length(regexall(var.region, each.key)) == 1 ? each.key : "com.amazonaws.${var.region}.${each.key}"
  service_type = "Interface"
}

