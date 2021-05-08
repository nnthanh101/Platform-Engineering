variable "vpc_name" {
  default = ""
}

variable "region" {
  default = "ap-southeast-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Parameter Store lookups
# ---------------------------------------------------------------------------------------------------------------------
variable "parameter_store_role" {
  description = "The role to assume when accessing parameter store."
  type        = string
  default     = ""
}

# variable "parameter_store_region" {
#   description = "The region to use when accessing parameter store."
#   type        = string
# }

# variable "path_to_vpc_private_subnet_ids" {
#   description = "The name of the parameter in parameter store where the private subnet ids are stored to use with the VPC endpoint."
#   type        = string
#   default     = ""
# }

# variable "path_to_vpc_private_route_table_ids" {
#   description = "The name of the parameter in parameter store where the private route table ids are stored to use with the VPC endpoint."
#   type        = string
#   default     = ""
# }

# ---------------------------------------------------------------------------------------------------------------------
# AWS VPC Endpoint configuration
# ---------------------------------------------------------------------------------------------------------------------
variable "create_sg_per_endpoint" {
  description = "Toggle to create a SecurityGroup for each VPC Endpoint. Defaults to using just one for all Interface Endpoints. Note that Gateway Endpoints don't support SecurityGroups."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The hard coded VPC ID to create the VPC endpoint for."
  type        = string
  default     = ""
}

# variable "private_subnet_ids" {
#   description = "The private subnet IDs to create the VPC endpoints with."
#   default     = ""
# }

# variable "route_table_ids" {
#   description = "One or more route table IDs. Applicable for endpoints of type Gateway."
#   type        = list(string)
#   default     = []
# }

variable "create_vpc_endpoints" {
  description = "Toggle to create VPC Endpoints."
  type        = bool
  default     = true
}

variable "sg_egress_rules" {
  description = "Egress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules."
  type = list(object({
    description      = string
    prefix_list_ids  = list(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
  }))
  default = [{
    description      = null
    prefix_list_ids  = null
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
  }]
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the VPC Endpoint SecurityGroup(s). Set to empty list to disable default rules."
  type = list(object({
    description      = string
    prefix_list_ids  = list(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
  }))
  default = [{
    description      = null
    prefix_list_ids  = null
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    security_groups  = null
  }]
}

variable "vpc_endpoint_services_gateway" {
  type        = list(string)
  description = "List of AWS Endpoint service names that are used to create VPC Interface Endpoints Type=Gateway"
  default = [
    "dynamodb"
  ]
}

variable "vpc_endpoint_services_interface" {
  type        = list(string)
  description = "List of AWS Endpoint service names that are used to create VPC Interface Endpoints Type=Interface"
  default = [
    "s3"
  ]
}
# ---------------------------------------------------------------------------------------------------------------------
# AWS Tags
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  description = "A map of tags to add to the VPC Endpoint and to the SecurityGroup(s)."
  type        = map(string)
  default     = {}
}
