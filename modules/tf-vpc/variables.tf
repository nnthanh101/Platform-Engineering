variable "tf-count" {
  default = 1
}

variable "aws_vpc" {
  type    = list
  default = ["tf-vpc","eks-vpc"]
}

variable "aws_cidr" {
  default = {
    "tf-vpc"  = "172.30.0.0/24"
    "eks-vpc" = "10.0.0.0/22"
  }
}
