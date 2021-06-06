variable "PROJECT_ID" {
  default = "terraform"
}

variable "org" {
  default = ""
}

variable "tenant" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "region" {
  default = "ap-southeast-1"
}

variable "vpc_name" {
  default = ""
}

variable "eks_cluster_name" {
  default = "EKS-Cluster"
}

variable "helm_chart_name" {
  type        = string
  default     = "aws-node-termination-handler"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "0.15.0"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "aws-node-termination-handler"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "Helm repository"
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "The K8s namespace in which the aws-node-termination-handler service account has been created"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-node-termination-handler"
}
