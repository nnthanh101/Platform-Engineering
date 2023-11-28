output "out_bastion_host_security_group_id" {
  value = data.terraform_remote_state.network.outputs.out_bastion_host_security_group_id
}
output "out_bastion_host_public_ip" {
  value = data.terraform_remote_state.network.outputs.out_bastion_public_ip
}
output "out_eks_cluster" {
  value = module.cluster.out_eks_cluster
}
