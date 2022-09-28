locals {
  label_order = [
    "tenant",
    "environment",
    "zone",
    "resource",
  "attributes"]
  org         = var.org == null ? "" : var.org
  tenant      = var.tenant == null ? "" : var.tenant
  environment = var.environment
  zone        = var.zone
  resource    = var.resource
  attributes  = var.attributes == null ? "" : var.attributes
  delimiter   = "-"
  input_tags  = var.tags == null ? {} : var.tags
  enabled     = var.enabled == null ? "false" : var.enabled

  id = join(local.delimiter, [local.tenant, local.environment, local.zone, local.resource])


  tags_context = {
    name        = local.id
    tenant      = local.tenant
    environment = local.environment
    zone        = local.zone
    resource    = local.resource

  }
  tags = merge(local.tags_context, local.input_tags)

}