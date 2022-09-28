output "ec2_image_builder_instance_role_arn" {
  value = aws_iam_role.ec2_image_builder_instance_role.arn
}

output "ec2_image_builder_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_image_builder_instance_profile.name
}

output "ec2_image_builder_pipeline_arns" {
  value = aws_imagebuilder_image_pipeline.ec2_image_builder_pipeline.*.arn
}

output "ec2_image_builder_pipeline_date_created" {
  value = aws_imagebuilder_image_pipeline.ec2_image_builder_pipeline.*.date_created
}

output "ec2_image_builder_pipeline_date_last_run" {
  value = aws_imagebuilder_image_pipeline.ec2_image_builder_pipeline.*.date_last_run
}

output "ec2_image_builder_pipeline_date_updated" {
  value = aws_imagebuilder_image_pipeline.ec2_image_builder_pipeline.*.date_updated
}

output "ec2_image_builder_pipeline_platform" {
  value = aws_imagebuilder_image_pipeline.ec2_image_builder_pipeline.*.platform
}

output "ec2_image_builder_distribution_configuration_arn" {
  value = aws_imagebuilder_distribution_configuration.ec2_image_builder_distribution_configuration.arn
}

output "ec2_image_builder_security_group_id" {
  value = aws_security_group.ec2_image_builder_security_group.id
}

output "ec2_image_builder_infrastructure_configuration_x86_id" {
  value = aws_imagebuilder_infrastructure_configuration.ec2_image_builder_infrastructure_configuration_x86.id
}

output "ec2_image_builder_infrastructure_configuration_arm64_id" {
  value = aws_imagebuilder_infrastructure_configuration.ec2_image_builder_infrastructure_configuration_arm64.id
}

output "ec2_image_builder_infrastructure_configuration_x86_arn" {
  value = aws_imagebuilder_infrastructure_configuration.ec2_image_builder_infrastructure_configuration_x86.arn
}

output "ec2_image_builder_infrastructure_configuration_arm64_arn" {
  value = aws_imagebuilder_infrastructure_configuration.ec2_image_builder_infrastructure_configuration_arm64.arn
}

output "ec2_imagebuilder_component_arn" {
  value = aws_imagebuilder_component.ec2_imagebuilder_component.arn
}

output "ec2_image_builder_image_recipe_arns" {
  value = aws_imagebuilder_image_recipe.ec2_image_builder_image_recipe.*.arn
}
