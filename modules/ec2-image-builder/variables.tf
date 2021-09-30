variable "PROJECT_ID" {
  default = ""
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

variable "vpc_name" {
  default = ""
}

variable "s3_bucket_imagebuilder" {
  default = "ec2imagebuilder"
}

variable "s3_bucket_imagebuilder_key" {
  default = "ec2imagebuilder"
}

variable "ec2_image_builder_pipeline_schedule" {
  type        = string
  description = "A CRON expression specifying when EC2 Image Builder will execute"
  default     = "cron(0 0 * * ? *)"
}

variable "aws_accounts_list" {
  type    = list(string)
  default = []
}

variable "region" {
  default = ""
}

variable "custom_ami_id" {
  default = "ami-0b13fa9f7b0f648c"
}

variable "ec2_image_builder_parent_images" {
  type    = list(string)
  default = ["amazon-linux-2-arm64", "amazon-linux-2-x86"]
}

variable "ec2_image_builder_pipeline_name" {
  default = "ec2_image_builder_pipeline"
}

variable "ec2_image_builder_keypair_name" {
  default = "keypair"
}

variable "ec2_image_builder_instance_types_x86" {
  type    = list(string)
  default = ["t3.medium", "t3.large"]
}

variable "ec2_image_builder_instance_types_arm64" {
  type    = list(string)
  default = ["m6g.medium", "c6g.medium", "r6g.medium"]
}

variable "ec2_image_builder_terminate_instance_on_failure" {
  type    = bool
  default = true
}

variable "ec2_image_builder_image_volume_size" {
  default = "100"
}

variable "ec2_image_builder_image_volume_type" {
  default = "gp2"
}

variable "ec2_image_builder_image_delete_on_termination" {
  type    = bool
  default = true
}

variable "ec2_image_builder_image_device_name" {
  default = "/dev/sda1"
}

variable "ec2_image_builder_component_file" {
  default = "component.yml"
}

variable "ec2_imagebuilder_component_name" {
  default = "ec2_imagebuilder_component"
}

variable "ec2_imagebuilder_component_platform" {
  default = "Linux"
}

variable "ec2_imagebuilder_component_version" {
  default = "1.0.1"
}

variable "ec2_image_builder_infrastructure_configuration_name_x86" {
  default = "ec2_image_builder_infrastructure_configuration_x86"
}

variable "ec2_image_builder_infrastructure_configuration_name_arm64" {
  default = "ec2_image_builder_infrastructure_configuration_arm64"
}

variable "ec2_image_builder_distribution_configuration_name" {
  default = "ec2_image_builder_distribution_configuration"
}

variable "ec2_image_builder_ami_distribution_configuration_name" {
  default = "ami"
}

variable "ec2_image_builder_instance_role_name" {
  default = "ec2_image_builder_instance_role"
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}
