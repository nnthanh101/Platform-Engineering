output "out_private_vpc" {
  value = module.private_vpc
}
output "out_public_vpc" {
  value = module.public_vpc
}
output "out_bastion_host_security_group_id" {
  value = aws_security_group.allow_ssh.id
}
output "out_private_subnets" {
  value = module.private_vpc.private_subnets
}
output "out_vpc_id" {
  value = module.private_vpc.vpc_id
}
output "out_bastion_public_ip" {
  value = module.ec2_instance.public_ip
}
