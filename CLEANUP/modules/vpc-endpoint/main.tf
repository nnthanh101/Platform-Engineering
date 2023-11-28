terraform {
  backend "s3" {
    region = var.region
  }
}
# ---------------------------------------------------------------------------------------------------------------------
# General VPC Endpoint Configuration
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "this" {
  for_each = local.security_groups

  description = var.create_sg_per_endpoint ? "VPC Interface ${each.key} Endpoint" : "VPC Interface Endpoints"
  vpc_id      = local.vpc_id

  dynamic "egress" {
    for_each = var.sg_egress_rules
    content {
      description      = egress.value["description"]
      prefix_list_ids  = egress.value["prefix_list_ids"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
      security_groups  = egress.value["security_groups"]
    }
  }

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      description      = ingress.value["description"]
      prefix_list_ids  = ingress.value["prefix_list_ids"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
      security_groups  = ingress.value["security_groups"]
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# For services that use Interfaces
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "interface_services" {
  for_each = local.interface_endpoints

  vpc_id             = local.vpc_id
  service_name       = each.key
  vpc_endpoint_type  = "Interface"
  auto_accept        = true
  subnet_ids         = local.subnet_ids
  security_group_ids = var.create_sg_per_endpoint ? [aws_security_group.this[each.key].id] : [aws_security_group.this["shared"].id]

  # private_dns_enabled = true # https://docs.aws.amazon.com/vpc/latest/userguide/vpce-interface.html#vpce-private-dns

  tags = merge(
    var.tags,
    tomap(
      { "Name" = "${local.vpc_id}-to-${each.key}" }
    )
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# For services that use Gateways
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "gateway_services" {
  for_each = local.gateway_endpoints

  vpc_id            = local.vpc_id
  service_name      = each.key
  vpc_endpoint_type = "Gateway"
  auto_accept       = true
  route_table_ids   = local.route_table_ids

  tags = merge(
    var.tags,
    tomap(
      { "Name" = "${local.vpc_id}-to-${each.key}" }
    )
  )
}
