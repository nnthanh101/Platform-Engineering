/*----------------------------------------------------------------*/
//LABEL NAMING FIELDS
/*----------------------------------------------------------------*/
variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS Region"
}
variable "org" {
  type        = string
  description = "tenant, which could be your organization name, e.g. aws'"
  default     = ""
}
variable "tenant" {
  type        = string
  description = "Account Name or unique account unique id e.g., apps or management or aws007"
  default     = ""
}
variable "environment" {
  type        = string
  default     = ""
  description = "zone, e.g. 'prod', 'preprod' "
}

variable "zone" {
  type        = string
  description = "Environment, e.g. 'load', 'zone', 'dev', 'uat'"
  default     = ""
}

variable "resource" {
  type        = string
  description = "Solution name, e.g. 'app' or 'cluster'"
  default     = ""
}

variable "attributes" {
  type        = string
  default     = ""
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "enabled" {
  type        = bool
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
  default     = true
}