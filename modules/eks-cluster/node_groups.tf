# resource "aws_eks_node_group" "public" {
#   node_group_name = "public"
#   node_role_arn = aws_iam_role.eks_nodes.arn
#   cluster_name = data.aws_eks_cluster.cluster.name
#   subnet_ids = data.aws_subnet_ids.public.ids
# 
#   scaling_config  {
#     desired_size = var.node_public_desired_size
#     max_size = var.node_public_max_size
#     min_size = var.node_public_min_size
#   }
# 
#   launch_template  {
#     id      = data.aws_launch_template.ondemand.id
#     version = data.aws_launch_template.ondemand.latest_version
#   }
# 
#   labels = {
#     SubnetType = var.NODE_SELECTOR_PUBLIC
#     NodeGroupType = var.NODE_SELECTOR_MANAGED_NODE_GROUP
#     NodeLifeCycle = var.NODE_SELECTOR_NORMAL
#   }
# 
#   tags = {
#     ProjectID = var.PROJECT_ID
#     "kubernetes.io/cluster/${local.cluster_name}" = "owned"
#     NodeLifeCycle = var.NODE_SELECTOR_NORMAL
#     SubnetType = var.NODE_SELECTOR_PUBLIC
#     NodeGroupType = var.NODE_SELECTOR_MANAGED_NODE_GROUP
#   }
#       
#   depends_on = [
#     data.aws_launch_template.ondemand,
#     aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
#     aws_iam_role_policy_attachment.aws_eks_cni_policy,
#     aws_iam_role_policy_attachment.ec2_read_only,
#   ]
# }
# 
# resource "aws_eks_node_group" "private" {
#   node_group_name = "private"
#   node_role_arn = aws_iam_role.eks_nodes.arn
#   cluster_name = data.aws_eks_cluster.cluster.name
#   subnet_ids = data.aws_subnet_ids.private.ids
# 
#   scaling_config  {
#     desired_size  = var.node_private_desired_size
#     max_size      = var.node_private_max_size
#     min_size      = var.node_private_min_size
#   }
# 
#   launch_template  {
#     id      = data.aws_launch_template.ondemand.id
#     version = data.aws_launch_template.ondemand.latest_version
#   }
# 
#   labels = {
#     SubnetType    = var.NODE_SELECTOR_PRIVATE
#     NodeGroupType = var.NODE_SELECTOR_MANAGED_NODE_GROUP
#     NodeLifeCycle = var.NODE_SELECTOR_NORMAL
#   }
# 
#   tags = {
#     ProjectID = var.PROJECT_ID
#     "kubernetes.io/cluster/${local.cluster_name}" = "owned"
#     NodeLifeCycle = var.NODE_SELECTOR_NORMAL
#     SubnetType = var.NODE_SELECTOR_PRIVATE
#     NodeGroupType = var.NODE_SELECTOR_MANAGED_NODE_GROUP
#   }
#       
#   depends_on = [
#     data.aws_launch_template.ondemand,
#     aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
#     aws_iam_role_policy_attachment.aws_eks_cni_policy,
#     aws_iam_role_policy_attachment.ec2_read_only,
#   ]
# }
# 
# ####
# # Launch Template with AMI
# #####
# data "aws_ssm_parameter" "cluster" {
#   name = "/aws/service/eks/optimized-ami/${data.aws_eks_cluster.cluster.version}/amazon-linux-2/recommended/image_id"
# }
# 
# data "aws_launch_template" "ondemand" {
#   name = aws_launch_template.ondemand.name
# 
#   depends_on = [aws_launch_template.ondemand]
# }
# 
# resource "aws_launch_template" "ondemand" {
#   image_id               = data.aws_ssm_parameter.cluster.value
#   instance_type          = "c5.large"
#   name                   = "${var.PROJECT_ID}-eks-launch-template"
#   update_default_version = true
# 
#   block_device_mappings {
#     device_name = "/dev/sda1"
# 
#     ebs {
#       volume_size = var.node_ebs_size
#     }
#   }
# 
#   vpc_security_group_ids = [aws_security_group.eks_nodes.id]
#   
#   tag_specifications {
#     resource_type = "instance"
# 
#     tags = {
#       Name                        = "${var.PROJECT_ID}-eks-node-group-instance-name"
#       ProjectID                   = var.PROJECT_ID
#       "kubernetes.io/cluster/${local.cluster_name}" = "owned"
#     }
#   }
# 
#   user_data = base64encode(templatefile("userdata.tpl", { CLUSTER_NAME = data.aws_eks_cluster.cluster.name, B64_CLUSTER_CA = data.aws_eks_cluster.cluster.certificate_authority[0].data, API_SERVER_URL = data.aws_eks_cluster.cluster.endpoint }))
# }
# 
