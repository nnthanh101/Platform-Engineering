terraform {
  backend "s3" {
    region = var.region
  }
}

provider "aws" {
  version = "~> 3.36"
  region  = var.region
}

data "aws_vpc" "eks-vpc" {
  filter {
    name = "tag:Name"

    values = [
      "${var.vpc_name}",
    ]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.eks-vpc.id}"

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

resource "aws_security_group" "efs" {
  name        = "${var.PROJECT_ID}-efs-sg"
  description = "${var.PROJECT_ID}-EFS-SG"
  vpc_id      = data.aws_vpc.eks-vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.eks-vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PROJECT_ID}-efs-sg"
  }
}

resource "aws_efs_file_system" "this" {
  creation_token = var.PROJECT_ID
  encrypted = true

  tags = {
    Name = "${var.PROJECT_ID}-EFS"
    PROJECT_ID = var.PROJECT_ID
  }
}

resource "aws_efs_mount_target" "this" {
  count          = length(data.aws_subnet_ids.private.ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = tolist(data.aws_subnet_ids.private.ids)[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "this" {
  file_system_id  = aws_efs_file_system.this.id

  root_directory {
    path            = "/data"
    creation_info {
      owner_uid       = 2500
      owner_gid       = 2500
      permissions     = 0755
    }
  }

  tags = {
    Name = "${var.PROJECT_ID}-EFS-AP"
    ProjectID = var.PROJECT_ID
  }
}
