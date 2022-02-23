variable "region" {
  description = "Please enter the region used to deploy this infrastructure"
  type        = string
}
variable "vpc_private_cidr" {
  description = "Please enter the CIDR for the private VPC"
  type        = string
}
variable "azs_private" {
  description = "Please enter a list of Availability zones for the private subnets"
  type        = any
}
variable "private_subnets" {
  description = "Please enter a list of CIDR ranges for the private subnets in the availability zones"
  type        = any
}
variable "vpc_public_cidr" {
  description = "Please enter a CIDR for the public VPC"
  type        = string
}
variable "azs_public" {
  description = "Please enter a list of Availability zones for the public subnets"
  type        = any
}
variable "public_subnets" {
  description = "Please enter a list of CIDR ranges for the public subnets in the availability zones"
  type        = any
}
variable "bastion_host_key_name" {
  description = "Please enter the name of the SSH key pair that should be assigned to the bastion host"
  type        = string
}
variable "ssh_bastion_cidr" {
  description = "Please enter a list of CIDR range(s) that are allowed to access the Bastion Host - Usually these are your corporate CIDR ranges - You can also restrict access to only your IP address by using /32 as prefix e.g. [\"192.168.10.10/32\"] - [\"0.0.0.0/0\"] allows access from all IPv4 adresses but is not recommended"
  type        = list(string)
} 
