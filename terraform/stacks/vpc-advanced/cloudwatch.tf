#######################
# CloudWatch Log group
#######################
resource "aws_cloudwatch_log_group" "flow_log" {
  name = local.cloudwatch_log_group_name
  count = local.flow_log_to_s3 ? 0 : 1
}
