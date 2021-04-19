
output "launch_template_id" {
  value = aws_launch_template.default.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.default.latest_version
}