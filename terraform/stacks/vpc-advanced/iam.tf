###########
# IAM Role
###########
resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  count = local.flow_log_to_s3 ? 0 : 1
  name_prefix        = "${var.PROJECT_ID}-vpc-flow-log-role-"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  count       = local.flow_log_to_s3 ? 0 : 1
  role        = aws_iam_role.vpc_flow_log_cloudwatch[0].name
  policy_arn  = aws_iam_policy.vpc_flow_log_cloudwatch[0].arn
}

resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  count       = local.flow_log_to_s3 ? 0 : 1
  name_prefix = "vpc-flow-log-cloudwatch-"
  policy      = data.aws_iam_policy_document.vpc_flow_log_cloudwatch.json
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  statement {
    sid     = "AWSVPCFlowLogsPushToCloudWatch"

    effect  = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "flow_log_s3" {
  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    effect  = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = ["arn:aws:s3:::${local.s3_bucket_name}/AWSLogs/*"]
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    effect  = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = ["arn:aws:s3:::${local.s3_bucket_name}"]
  }
}
