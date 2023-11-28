variable "region" {
  description = "Please enter the region used to deploy this infrastructure"
  type        = string
}
variable "eks_cluster_version" {
  description = "Please enter the EKS cluster version"
  type        = string
}
variable "eks_cluster_name" {
  description = "Please enter an EKS cluster name"
  type        = string
}
variable "lin_instance_type" {
  description = "Please enter the instance type to be used for the Linux worker nodes"
  type        = string
}
variable "lin_min_size" {
  description = "Please enter the minimal size for the Linux ASG"
  type        = string
}
variable "lin_max_size" {
  description = "Please enter the maximal size for the Linux ASG"
  type        = string
}
variable "lin_desired_size" {
  description = "Please enter the desired size for the Linux ASG"
  type        = string
}
variable "win_min_size" {
  description = "Please enter the minimal size for the Windows ASG"
  type        = string
}
variable "win_max_size" {
  description = "Please enter the maximal size for the Windows ASG"
  type        = string
}
variable "win_desired_size" {
  description = "Please enter the desired size for the Windows ASG"
  type        = string
}
variable "win_instance_type" {
  description = "Please enter the instance type to be used for the Windows worker nodes"
  type        = string
}
variable "node_host_key_name" {
  description = "Please enter the name of the SSH key pair that should be assigned to the worker nodes of the cluster"
  type        = string
}
