variable "PROJECT_ID" {
  default = ""
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
  default = ""
}
variable "vpc_name" {
  default = ""
}

variable "eks_cluster_name" {
  default = ""
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}

variable "helm_chart_name" {
  type        = string
  default     = "aws-efs-csi-driver"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "2.0.0"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "aws-efs-csi-driver"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  description = "Helm repository"
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "The K8s namespace in which the node-problem-detector service account has been created"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/stable/cluster-autoscaler"
}
