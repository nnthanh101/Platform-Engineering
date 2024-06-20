terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.72.0"
    }
  }
}
provider "aws" {
  region = var.region
}
data "aws_caller_identity" "current" {}
locals {
    account_id = data.aws_caller_identity.current.account_id
}
#### Nodegroups - Images

data "aws_ami" "lin_ami" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amazon-eks-node-${var.eks_cluster_version}-*"]
    }
}
data "aws_ami" "win_ami" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["Windows_Server-2019-English-Core-EKS_Optimized-${var.eks_cluster_version}-*"]
    }
}
resource "aws_kms_key" "eks" {
  description = "EKS Encryption Key"
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version = "18.6.0"
  vpc_id = var.vpc_id
  cluster_name = var.eks_cluster_name
  subnet_ids = var.private_subnet_ids
  cluster_enabled_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  cluster_version                 = var.eks_cluster_version
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]
  ### Allow SSM access for Nodes
  self_managed_node_group_defaults = {
    iam_role_additional_policies           = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  }
  tags = {
    Name = "${var.eks_cluster_name}"
  }
  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ## Enable access from bastion host to Nodes
    ingress_bastion = {
      description       = "Allow access from Bastion Host"
      type              = "ingress"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      source_security_group_id = var.bastion_host_SG_id
}
    ## Enable RDP access from bastion host to Nodes
    ingress_bastion_win = {
      description       = "Allow access from Bastion Host via RDP"
      type              = "ingress"
      from_port         = 3389
      to_port           = 3389
      protocol          = "tcp"
      source_security_group_id = var.bastion_host_SG_id
}
  }
## Enable access from bastion host to EKS endpoint
    cluster_security_group_additional_rules = {
        ingress_bastion = {
          description       = "Allow access from Bastion Host"
          type              = "ingress"
          from_port         = 443
          to_port           = 443
          protocol          = "tcp"
          source_security_group_id = var.bastion_host_SG_id
    }
      }
self_managed_node_groups = {
    linux = {
      platform = "linux"
      name = "linux"
      public_ip    = false
      instance_type = var.lin_instance_type
      key_name = var.node_host_key_name
      desired_size = var.lin_desired_size
      max_size = var.lin_max_size
      min_size = var.lin_min_size
      ami_id = data.aws_ami.lin_ami.id
    }
    windows = {
      platform = "windows"
      name = "windows"
      public_ip    = false
      instance_type = var.win_instance_type
      key_name = var.node_host_key_name
      desired_size = var.win_desired_size
      max_size = var.win_max_size
      min_size = var.win_min_size
      ami_id = data.aws_ami.win_ami.id
    }
}
}
### Prerequisites for Windows Node enablement
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_id
}

locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.eks.cluster_id
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.eks.cluster_id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.this.token
      }
    }]
  })
}
### Apply changes to aws_auth
### Windows node Cluster enablement:  https://docs.aws.amazon.com/eks/latest/userguide/windows-support.html
resource "null_resource" "apply" {
  triggers = {
    kubeconfig = base64encode(local.kubeconfig)
    cmd_patch  = <<-EOT
      kubectl create configmap aws-auth -n kube-system --kubeconfig <(echo $KUBECONFIG | base64 --decode)
      kubectl patch configmap/aws-auth --patch "${module.eks.aws_auth_configmap_yaml}" -n kube-system --kubeconfig <(echo $KUBECONFIG | base64 --decode)
      kubectl get cm aws-auth -n kube-system -o json --kubeconfig <(echo $KUBECONFIG | base64 --decode) | jq --arg add "`cat yaml-templates/additional_roles_aws_auth.yaml`" '.data.mapRoles += $add' | kubectl apply --kubeconfig <(echo $KUBECONFIG | base64 --decode) -f -
      kubectl apply --kubeconfig <(echo $KUBECONFIG | base64 --decode) -f yaml-templates/vpc-resource-controller-configmap.yaml
    EOT
  }
    provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
    command = self.triggers.cmd_patch
  }
}

# VPC Endpoints for private EKS cluster
# https://docs.aws.amazon.com/eks/latest/userguide/private-clusters.html#vpc-endpoints-private-clusters

#### Route Tables for S3 Gateway
data "aws_route_table" "private-a" {
  subnet_id = var.private_subnet_ids[0]
}
data "aws_route_table" "private-b" {
  subnet_id = var.private_subnet_ids[1]
}
data "aws_route_table" "private-c" {
  subnet_id = var.private_subnet_ids[2]
}

resource "aws_vpc_endpoint" "vpce_s3_gw" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
      Version = "2008-10-17"
    }
  )
  route_table_ids = [
    "${data.aws_route_table.private-a.id}",
    "${data.aws_route_table.private-b.id}",
    "${data.aws_route_table.private-c.id}"
  ]
  service_name       = format("com.amazonaws.${var.region}.s3")
  vpc_endpoint_type  = "Gateway"
  vpc_id = var.vpc_id
}
resource "aws_vpc_endpoint" "vpce_ec2" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.ec2")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id
}
resource "aws_vpc_endpoint" "vpce_logs" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.logs")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id
}
resource "aws_vpc_endpoint" "vpce_ecrapi" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.ecr.api")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id
}
resource "aws_vpc_endpoint" "vpce_autoscaling" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.autoscaling")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id

}

resource "aws_vpc_endpoint" "vpce_sts" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.sts")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id

}
resource "aws_vpc_endpoint" "vpce_elb" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.elasticloadbalancing")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id
}
resource "aws_vpc_endpoint" "vpce_ecrdkr" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.ecr.dkr")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id
}
### SSM Access
resource "aws_vpc_endpoint" "vpce_ec2messages" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.ec2messages")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id
}

resource "aws_vpc_endpoint" "vpce_ssm" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.ssm")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id
}

resource "aws_vpc_endpoint" "vpce_ssmmessages" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  security_group_ids = [module.eks.node_security_group_id,module.eks.cluster_security_group_id]
  service_name = format("com.amazonaws.${var.region}.ssmmessages")
  subnet_ids = var.private_subnet_ids
  vpc_endpoint_type = "Interface"
  vpc_id = var.vpc_id

}

