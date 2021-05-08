# ---------------------------------------------------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Configuration values
  vpc_id          = data.aws_vpc.vpc.id
  subnet_ids      = data.aws_subnet_ids.private.ids
  route_table_ids = data.aws_route_tables.rtb.ids
  # Split Endpoints by their type
  gateway_endpoints   = toset([for e in data.aws_vpc_endpoint_service.gateway : e.service_name if e.service_type == "Gateway"])
  interface_endpoints = toset([for e in data.aws_vpc_endpoint_service.interface : e.service_name if e.service_type == "Interface"])

  # Only Interface Endpoints support SGs
  security_groups = toset(var.create_vpc_endpoints ? var.create_sg_per_endpoint ? local.interface_endpoints : ["shared"] : [])
}
