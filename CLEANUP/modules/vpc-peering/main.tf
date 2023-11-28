terraform {
  backend "s3" {
    region = var.region
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "origin_vpc" {
  filter {
    name = "tag:Name"

    values = [
      "${var.PROJECT_ID}-${var.origin_vpc_name}",
    ]
  }
}

data "aws_vpc" "destination_vpc" {
  filter {
    name = "tag:Name"

    values = [
      "${var.PROJECT_ID}-${var.destination_vpc_name}",
    ]
  }
}

data "aws_route_tables" "origin_vpc_private_route_tables" {
  vpc_id = data.aws_vpc.origin_vpc.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_route_tables" "destination_vpc_private_route_tables" {
  vpc_id = data.aws_vpc.destination_vpc.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = data.aws_vpc.origin_vpc.id
  vpc_id      = data.aws_vpc.destination_vpc.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
    var.tags,
    tomap(
      { "Name" = "VPC Peering between ${var.PROJECT_ID}-${var.origin_vpc_name} and ${var.PROJECT_ID}-${var.destination_vpc_name}" }
    )
  )
}

resource "aws_route" "origin_vpc_routes" {
  count                     = length(tolist(data.aws_route_tables.origin_vpc_private_route_tables.ids))
  route_table_id            = tolist(data.aws_route_tables.origin_vpc_private_route_tables.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.destination_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "destination_vpc_routes" {
  count                     = length(tolist(data.aws_route_tables.destination_vpc_private_route_tables.ids))
  route_table_id            = tolist(data.aws_route_tables.destination_vpc_private_route_tables.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.origin_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
