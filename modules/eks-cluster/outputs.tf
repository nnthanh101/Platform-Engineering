output "eks_cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "eks_cluster_host" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_ca_certificate" {
  value = data.aws_eks_cluster.cluster.certificate_authority.0.data
}

output "eks_cluster_token" {
  value     = data.aws_eks_cluster_auth.cluster.token
  sensitive = true
}

output "node_group_names" {
  value = module.eks_cluster.node_groups
}

output "asg_names" {
  value = module.eks_cluster.workers_asg_names
}

output "security_group_ids" {
  value = module.eks_cluster.security_group_rule_cluster_https_worker_ingress
}

output "private_subnets" {
  value = data.aws_subnet_ids.private.ids
}

