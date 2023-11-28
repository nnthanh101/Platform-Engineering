############
# S3 bucket
############
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.25.0"

  count = local.flow_log_to_s3 ? 1 : 0

  bucket        = local.s3_bucket_name
  policy        = data.aws_iam_policy_document.flow_log_s3.json
  force_destroy = true

  tags = {
    ProjectID = var.PROJECT_ID
    Name      = "vpc-flow-logs-s3-bucket"
  }
}
