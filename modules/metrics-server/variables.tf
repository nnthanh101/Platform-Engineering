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

# metrics-server

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

# Helm

variable "helm_chart_name" {
  type        = string
  default     = "metrics-server"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "5.8.9"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "metrics-server"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://charts.bitnami.com/bitnami"
  description = "Helm repository"
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "The K8s namespace in which the metrics-server service account has been created"
}

variable "settings" {
  type        = map(any)
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/stable/metrics-server"

  default = {
    "securePort" = 4443
  }
}

variable "extra_args" {
  type = map(any)
  default = {
    "kubelet-preferred-address-types" = "InternalIP"
    "v"                               = 4
    "kubelet-insecure-tls"            = true
  }
}

variable "node_selector" {
  type = map(any)
  default = {
    "InstanceType" = "x86"
  }
}
