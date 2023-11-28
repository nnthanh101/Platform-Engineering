output "cw_loggroup_name" {
  description = "EKS Cloudwatch group Name"
  value       = aws_cloudwatch_log_group.eks-worker-logs.name
}
output "cw_loggroup_arn" {
  description = "EKS Cloudwatch group arn"
  value       = aws_cloudwatch_log_group.eks-worker-logs.arn
}


