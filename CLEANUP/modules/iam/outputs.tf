
// output "eks_autoscaler_arn" {
//   description = "EKS autoscaler policy ARN"
//   value       = aws_iam_policy.eks-autoscaler-policy.arn
// }
output "eks_rbac_admin_arn" {
  description = "EKS Admin ARN"
  value       = aws_iam_role.cluster_admin_access.arn
}

output "eks_rbac_devs_arn" {
  description = "EKS Developer ARN"
  value       = aws_iam_role.cluster_devs_access.arn
}
