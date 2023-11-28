variable "PROJECT_ID" {
  default = "terraform"
}

variable "org" {
  default = ""
}

variable "tenant" {
  default = ""
}

variable "environment" {
  default = ""
}
variable "region" {
  default = "ap-southeast-1"
}
variable "vpc_name" {
  default = ""
}
variable "eks_cluster_name" {
  default = "EKS-Cluster"
}
variable "instance_type" {
  default = "r5.large"
}
variable "instance_type_Graviton2" {
  default = "m6g.large"
}
variable "instance_type_Spot" {
  default = "t3.medium"
}
variable "instance_type_AMD" {
  default = "t3.medium"
}
variable "cluster_version" {
  default = "1.20"
}

variable "config_output_path" {
  default = "../../artifacts/"
}

variable "asg_ondemand_name" {
  default = "ondemand-"
}

variable "asg_ondemand_public_name" {
  default = "ondemand-public-"
}

variable "asg_spot_name" {
  default = "spot-"
}
variable "namespace" {
  default = "api"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    #   {
    #     rolearn  = "arn:aws:iam::ACCOUNT_ID:role/ROLENAME"
    #     username = "ROLENAME"
    #     groups   = ["system:masters"]
    #   }
  ]
}
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    #   {
    #     userarn  = "arn:aws:iam::ACCOUNT_ID:user/USERNAME"
    #     username = "USERNAME"
    #     groups   = ["system:masters"]
    #   }
  ]
}
variable "node_public_max_size" {
  default = 10
}
variable "node_public_min_size" {
  default = 1
}
variable "node_public_desired_size" {
  default = 2
}

variable "node_private_desired_size" {
  default = 5
}
variable "node_private_max_size" {
  default = 10
}
variable "node_private_min_size" {
  default = 4
}

variable "node_spot_private_desired_size" {
  default = 2
}
variable "node_spot_private_max_size" {
  default = 10
}
variable "node_spot_private_min_size" {
  default = 1
}

variable "node_ebs_size" {
  default = 50
}

variable "NODE_SELECTOR_PRIVATE" {
  default = "PrivateSubnet=true"
}
variable "NODE_SELECTOR_PUBLIC" {
  default = "PublicSubnet=true"
}
variable "NODE_SELECTOR_MANAGED_NODE_GROUP" {
  default = "ManagedNodeGroup=true"
}
variable "NODE_SELECTOR_NORMAL" {
  default = "\"node.kubernetes.io/lifecycle\"=\"normal\""
}
variable "NODE_SELECTOR_SPOT" {
  default = "\"node.kubernetes.io/lifecycle\"=\"spot\""
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}
