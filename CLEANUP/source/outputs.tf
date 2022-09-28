output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks-label.id
}

// output "configure_kubectl" {
//   description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
//   value       = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_id}"
// }
