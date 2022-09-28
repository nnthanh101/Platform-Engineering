
output "id" {
  value       = local.enabled ? local.id : ""
  description = "aws resource id"
}

output "tags" {
  value       = local.enabled ? local.tags : {}
  description = "aws resource tags"
}