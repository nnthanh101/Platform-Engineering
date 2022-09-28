data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"

    values = [
      "${var.vpc_name}",
    ]
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Name"
    values = [
      "*private*"
    ]
  }
}

data "aws_caller_identity" "current" {}
### IAM Policy for Kube2IAM
resource "aws_iam_policy" "kube2iam" {
  name        = "${var.PROJECT_ID}-kube2iam"
  path        = "/"
  description = "${var.PROJECT_ID}-kube2iam"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.PROJECT_ID}-eks-*"
      ]
    }
  ]
}
EOF
}

### IAM Policy for CloudWatch Agent
data "aws_iam_policy" "cloudwatch_agent" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_ami" "bottlerocket_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${var.cluster_version}-*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
