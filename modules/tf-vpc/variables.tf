# variable "terraform_version" {
#   type        = string
#   default     = "Terraform"
#   description = "Terraform Version"
# }
# variable "org" {
#   type        = string
#   description = "tenant, which could be your organization name, e.g. aws'"
#   default     = "aws"
# }
# variable "tenant" {
#   type        = string
#   description = "Account Name or unique account unique id e.g., apps or management or job4u"
#   default     = ""
# }
# variable "environment" {
#   type        = string
#   default     = "preprod"
#   description = "Environment area, e.g. prod or preprod "
# }
# variable "zone" {
#   type        = string
#   description = "zone, e.g. dev or qa or load or ops etc..."
#   default     = ""
# }
# variable "attributes" {
#   type        = string
#   default     = ""
#   description = "Additional attributes (e.g. `1`)"
# }
# variable "tags" {
#   type        = map(string)
#   default     = {}
#   description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
# }

# variable "Project_ID" {
#   default = ""
# }

variable "profile" {
  default = "default"
}

variable "region" {
  default = "ap-southeast-1"
}

# variable "azs" {
#   default = {
#     "ap-southeast-1" = "ap-southeast-1a,ap-southeast-1b,ap-southeast-1c"
#   }
# }

variable "tf-count" {
  default = 1
}

variable "aws_vpc" {
  type    = list(any)
  default = ["tf-vpc", "eks-vpc"]
}

variable "aws_cidr" {
  default = {
    "tf-vpc"  = "172.30.0.0/24"
    "eks-vpc" = "10.0.0.0/22"
  }
}
