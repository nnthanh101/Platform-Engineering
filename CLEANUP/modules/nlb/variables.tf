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

variable "cluster_version" {
  default = ""
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}

# nlb-ingress

variable "enabled" {
  type    = bool
  default = true
}

# Helm

variable "helm_chart_name" {
  default = "ingress-nginx"
}

variable "helm_chart_version" {
  default = "3.32.0"
}

variable "helm_release_name" {
  default = "aws-nlb-ingress-controller"
}

variable "helm_repo_url" {
  default = "https://kubernetes.github.io/ingress-nginx"
}

# K8S

variable "k8s_namespace" {
  default     = "nlb-ingress"
  description = "The k8s namespace in which the nlb-ingress service account has been created"
}

variable "k8s_service_account_name" {
  default     = "aws-nlb-ingress-controller"
  description = "The k8s nlb-ingress service account name"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx#configuration"
}

variable "node_selector" {
  type = map(any)
  default = {
    "InstanceType" = "x86"
  }
}
