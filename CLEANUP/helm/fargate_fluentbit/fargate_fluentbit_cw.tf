data "aws_region" "current" {}

#-------------------------------------------------------------------------------------------------
#IAM Policy for Fargate Fluentbit
#--------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "eks-fargate-logging-policy" {
  name        = "${var.eks_cluster_id}-fargate-log-policy"
  description = "Allow fargate profiles to writ logs to CW"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Action": [
			"logs:CreateLogStream",
			"logs:CreateLogGroup",
			"logs:DescribeLogStreams",
			"logs:PutLogEvents"
		],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "fargate_profile_role" {
  role       = var.fargate_iam_role
  policy_arn = aws_iam_policy.eks-fargate-logging-policy.arn
}


resource "kubernetes_namespace" "aws_observability" {
  metadata {
    name = "aws-observability"

    labels = {
      aws-observability = "enabled"
    }
  }
}

resource "kubernetes_config_map" "aws_logging" {
  metadata {
    name      = "aws-logging"
    namespace = "aws-observability"
  }

  data = {
    "output.conf" = "[OUTPUT]\n    Name cloudwatch_logs\n    Match   *\n    region ${data.aws_region.current.id}\n    log_group_name /aws/eks/${var.eks_cluster_id}/fluent-bit-cloudwatch\n    log_stream_prefix from-fluent-bit-\n    auto_create_group On\n"
  }
}

