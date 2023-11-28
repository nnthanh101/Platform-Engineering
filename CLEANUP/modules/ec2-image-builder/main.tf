# AWS VPC Endpoints needed for EC2 Image Builder (Events, SSMMessages, Monitoring, EC2Messages, ImageBuilder, S3, Logs, SSM)
terraform {
  backend "s3" {
    region = var.region
  }
}

locals {
  private_subnet_0_id = tolist(data.aws_subnet_ids.private.ids)[0]
  vpc_id              = data.aws_vpc.vpc.id
}

resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = lower("${var.PROJECT_ID}-log-bucket")
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}


resource "aws_s3_bucket" "this" {
  bucket = lower("${var.PROJECT_ID}-${var.s3_bucket_imagebuilder}")
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }

  tags = merge(
    var.tags,
    tomap(
      { "Name" = "${var.PROJECT_ID}-${var.s3_bucket_imagebuilder}" }
    )
  )
}

resource "aws_s3_bucket_object" "this" {
  key    = var.s3_bucket_imagebuilder_key
  bucket = aws_s3_bucket.this.id
  source = var.ec2_image_builder_component_file
  tags   = var.tags
}

# AWS EC2 Image Builder Distribution Configuration
resource "aws_imagebuilder_distribution_configuration" "ec2_image_builder_distribution_configuration" {
  name = var.ec2_image_builder_distribution_configuration_name

  distribution {
    ami_distribution_configuration {
      ami_tags = merge(
        var.tags,
        tomap(
          { "Name" = var.ec2_image_builder_ami_distribution_configuration_name }
        )
      )

      name = "${var.ec2_image_builder_ami_distribution_configuration_name} Version:{{imagebuilder:buildVersion}} Date:{{imagebuilder:buildDate}}"

      launch_permission {
        user_ids = var.aws_accounts_list
      }
    }

    region = var.region
  }
}

resource "aws_iam_role" "ec2_image_builder_instance_role" {
  name = var.ec2_image_builder_instance_role_name
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonInspectorFullAccess"
  ]
  assume_role_policy = join("", data.aws_iam_policy_document.ec2_image_builder__assume_role_policy.*.json)

  tags = merge(
    var.tags,
    tomap(
      { "Name" = var.ec2_image_builder_instance_role_name }
    )
  )
}

data "aws_iam_policy_document" "ec2_image_builder__assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "ec2_image_builder_instance_profile" {
  name = "ec2_image_builder_instance_profile"
  role = aws_iam_role.ec2_image_builder_instance_role.name
  path = "/"
}

# EC2 Image Builder Instance SecurityGroup
resource "aws_security_group" "ec2_image_builder_security_group" {
  name        = "ec2_image_builder_security_group"
  description = "EC2 Security Group"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    tomap(
      { "Name" = "ec2_image_builder_security_group" }
    )
  )
}

# AWS EC2 Image Builder Infrastructure Configuration
resource "aws_imagebuilder_infrastructure_configuration" "ec2_image_builder_infrastructure_configuration_x86" {
  description           = "EC2 Image Builder Infrastructure Configuration"
  instance_profile_name = aws_iam_instance_profile.ec2_image_builder_instance_profile.name
  instance_types        = var.ec2_image_builder_instance_types_x86
  # key_pair                      = var.ec2_image_builder_keypair_name
  name                          = var.ec2_image_builder_infrastructure_configuration_name_x86
  security_group_ids            = ["${aws_security_group.ec2_image_builder_security_group.id}"]
  subnet_id                     = local.private_subnet_0_id
  terminate_instance_on_failure = var.ec2_image_builder_terminate_instance_on_failure
  resource_tags = merge(
    var.tags,
    tomap(
      {
        "AMIVersion"   = "Version:{{imagebuilder:buildVersion}}",
        "AMIBuildDate" = "Date:{{imagebuilder:buildDate}}"
      }
    )
  )

  tags = merge(
    var.tags,
    tomap(
      { "Name" = var.ec2_image_builder_infrastructure_configuration_name_x86 }
    )
  )
}

# AWS EC2 Image Builder Infrastructure Configuration
resource "aws_imagebuilder_infrastructure_configuration" "ec2_image_builder_infrastructure_configuration_arm64" {
  description           = "EC2 Image Builder Infrastructure Configuration"
  instance_profile_name = aws_iam_instance_profile.ec2_image_builder_instance_profile.name
  instance_types        = var.ec2_image_builder_instance_types_arm64
  # key_pair                      = var.ec2_image_builder_keypair_name
  name                          = var.ec2_image_builder_infrastructure_configuration_name_arm64
  security_group_ids            = ["${aws_security_group.ec2_image_builder_security_group.id}"]
  subnet_id                     = local.private_subnet_0_id
  terminate_instance_on_failure = var.ec2_image_builder_terminate_instance_on_failure
  resource_tags = merge(
    var.tags,
    tomap(
      {
        "AMIVersion"   = "Version:{{imagebuilder:buildVersion}}",
        "AMIBuildDate" = "Date:{{imagebuilder:buildDate}}"
      }
    )
  )

  tags = merge(
    var.tags,
    tomap(
      { "Name" = var.ec2_image_builder_infrastructure_configuration_name_arm64 }
    )
  )
}

resource "aws_imagebuilder_component" "ec2_imagebuilder_component" {
  name     = var.ec2_imagebuilder_component_name
  platform = var.ec2_imagebuilder_component_platform
  version  = var.ec2_imagebuilder_component_version
  uri      = "s3://${aws_s3_bucket.this.bucket}/${aws_s3_bucket_object.this.id}"
  tags     = var.tags
}

# AWS EC2 Image Builder Recipe
resource "aws_imagebuilder_image_recipe" "ec2_image_builder_image_recipe" {
  count = length(var.ec2_image_builder_parent_images)
  block_device_mapping {
    device_name = var.ec2_image_builder_image_device_name

    ebs {
      delete_on_termination = var.ec2_image_builder_image_delete_on_termination
      volume_size           = var.ec2_image_builder_image_volume_size
      volume_type           = var.ec2_image_builder_image_volume_type
    }
  }

  component {
    component_arn = aws_imagebuilder_component.ec2_imagebuilder_component.arn
  }

  name         = "${var.PROJECT_ID}-${var.ec2_image_builder_parent_images[count.index]}"
  parent_image = "arn:${data.aws_partition.current.partition}:imagebuilder:${var.region}:aws:image/${var.ec2_image_builder_parent_images[count.index]}/x.x.x"
  version      = "1.0.0"
  tags         = var.tags
}

# AWS EC2 Image Builder Pipeline
resource "aws_imagebuilder_image_pipeline" "ec2_image_builder_pipeline" {
  count                            = length(aws_imagebuilder_image_recipe.ec2_image_builder_image_recipe)
  name                             = "${var.ec2_image_builder_pipeline_name}-${var.ec2_image_builder_parent_images[count.index]}"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.ec2_image_builder_image_recipe[count.index].arn
  infrastructure_configuration_arn = trimsuffix(var.ec2_image_builder_parent_images[count.index], "arm64") != var.ec2_image_builder_parent_images[count.index] ? aws_imagebuilder_infrastructure_configuration.ec2_image_builder_infrastructure_configuration_arm64.arn : aws_imagebuilder_infrastructure_configuration.ec2_image_builder_infrastructure_configuration_x86.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.ec2_image_builder_distribution_configuration.arn

  schedule {
    schedule_expression = var.ec2_image_builder_pipeline_schedule
  }

  tags = var.tags
}

