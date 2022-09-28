##  Terraform state for S3 backend

//terraform {
//  backend "s3" {
//    bucket = ""
//    region = ""
//    key    = ""
//  }
//}

##  Terraform state for local backend
terraform {
  backend "local" {
    path = ""
  }
}