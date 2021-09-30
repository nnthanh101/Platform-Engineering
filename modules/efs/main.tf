terraform {
  backend "s3" {
    region = var.region
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
}

data "aws_caller_identity" "current" {}

locals {
  driver_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/eks/aws-efs-csi-driver"
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"

    values = [
      "${var.vpc_name}",
    ]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

resource "aws_security_group" "efs" {
  name        = "${var.PROJECT_ID}-efs"
  description = "${var.PROJECT_ID}-EFS-SG"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    tomap(
      { "Name" = "${var.PROJECT_ID}-efs" }
    )
  )
}

resource "aws_efs_file_system" "this" {
  creation_token = var.PROJECT_ID
  encrypted      = true

  tags = merge(
    var.tags,
    tomap(
      { "Name" = "${var.PROJECT_ID}-efs" }
    )
  )
}

resource "aws_efs_mount_target" "this" {
  count           = length(data.aws_subnet_ids.private.ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = tolist(data.aws_subnet_ids.private.ids)[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = "/data"
    creation_info {
      owner_uid   = 2500
      owner_gid   = 2500
      permissions = 0755
    }
  }

  tags = merge(
    var.tags,
    tomap({ "Name" = "${var.PROJECT_ID}-efs-ap" }
    )
  )
}

resource "aws_efs_access_point" "modules" {
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = "/modules"
    creation_info {
      owner_uid   = 2500
      owner_gid   = 2500
      permissions = 0755
    }
  }

  tags = merge(
    var.tags,
    tomap({ "Name" = "${var.PROJECT_ID}-efs-ap-modules" }
    )
  )
}

resource "aws_efs_access_point" "themes" {
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = "/themes"
    creation_info {
      owner_uid   = 2500
      owner_gid   = 2500
      permissions = 0755
    }
  }

  tags = merge(
    var.tags,
    tomap({ "Name" = "${var.PROJECT_ID}-efs-ap-themes" }
    )
  )
}

resource "aws_efs_access_point" "sites" {
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = "/sites"
    creation_info {
      owner_uid   = 2500
      owner_gid   = 2500
      permissions = 0755
    }
  }

  tags = merge(
    var.tags,
    tomap({ "Name" = "${var.PROJECT_ID}-efs-ap-sites" }
    )
  )
}

resource "aws_efs_access_point" "profiles" {
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = "/profiles"
    creation_info {
      owner_uid   = 2500
      owner_gid   = 2500
      permissions = 0755
    }
  }

  tags = merge(
    var.tags,
    tomap({ "Name" = "${var.PROJECT_ID}-efs-ap-profiles" }
    )
  )
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}


# Driver
resource "helm_release" "efs_csi_driver" {
  chart      = var.helm_chart_name
  namespace  = var.k8s_namespace
  name       = var.helm_release_name
  version    = var.helm_chart_version
  repository = var.helm_repo_url

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
