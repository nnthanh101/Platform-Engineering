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

// Modify the bucket and dynamoDB table that are used by Terraform
terraform {
  backend "s3" {
    bucket         = "academy4u-s3-state"
    key            = "network.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "academy4u-tf-lock"
  }
}
module "private_vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "academy4u-vpc-private"
  cidr                 = var.vpc_private_cidr
  azs                  = var.azs_private
  private_subnets      = var.private_subnets
  enable_dns_hostnames = true
  create_igw           = false
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
}
module "public_vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "academy4u-vpc-public"
  cidr                   = var.vpc_public_cidr
  create_egress_only_igw = false
  create_igw             = true
  azs                    = var.azs_public
  public_subnets         = var.public_subnets
  enable_dns_hostnames   = true
  enable_nat_gateway     = false
  enable_vpn_gateway     = false
}
resource "aws_iam_instance_profile" "ec2_admin_terraform" {
  name = "ec2_admin_terraform"
  role = aws_iam_role.ec2_admin_role.name
}

resource "aws_iam_role" "ec2_admin_role" {
  name = "ec2_admin_role_terraform"
  ### not recommend for productive use:
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  ###
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 3.0"
  name                   = "bastion-host"
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = var.bastion_host_key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = module.public_vpc.public_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.ec2_admin_terraform.name
  user_data = <<EOF
    #!/bin/bash
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
    sudo yum -y install git
    sudo yum -y install jq
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    kubectl version --short --client
EOF
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.public_vpc.vpc_id

  ingress {
    description     = "SSH from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.ssh_bastion_cidr
  }

  egress {
    description = "Allow egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
resource "aws_vpc_peering_connection" "bastion-private-EKS" {
  peer_vpc_id = module.public_vpc.vpc_id
  vpc_id      = module.private_vpc.vpc_id
  auto_accept = true
  tags = {
    Name = "VPC Peering between Bastion Host and private EKS cluster"
  }
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "peeringConnection-private-a" {
  route_table_id            = module.private_vpc.private_route_table_ids[0]
  destination_cidr_block    = module.public_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.bastion-private-EKS.id
}
resource "aws_route" "peeringConnection-private-b" {
  route_table_id            = module.private_vpc.private_route_table_ids[1]
  destination_cidr_block    = module.public_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.bastion-private-EKS.id
}
resource "aws_route" "peeringConnection-private-c" {
  route_table_id            = module.private_vpc.private_route_table_ids[2]
  destination_cidr_block    = module.public_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.bastion-private-EKS.id
}
resource "aws_route" "peeringConnection-public-a" {
  route_table_id            = module.public_vpc.public_route_table_ids[0]
  destination_cidr_block    = module.private_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.bastion-private-EKS.id
}

