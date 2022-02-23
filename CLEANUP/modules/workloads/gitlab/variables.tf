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

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

# Helm

variable "helm_chart_name" {
  type        = string
  default     = "gitlab"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "4.12.2"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "gitlab"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://charts.gitlab.io"
  description = "Helm repository"
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "gitlab"
  description = "The K8s namespace in which the gitlab-server service account has been created"
}

variable "settings" {
  type        = map(any)
  description = "Additional settings which will be passed to the Helm chart values, see https://charts.gitlab.io"

  default = {
    "certmanager.install" : false,
    "nginx-ingress.enabled" : false,
    "prometheus.install" : false,
    "registry.enabled" : false,
    "global.grafana.enabled" : false,
    "global.hosts.domain" : "code4beers.me",
    "global.hosts.https" : false,
    "global.ingress.class" : "nginx",
    "global.ingress.configureCertmanager" : false,
    "global.ingress.https" : false,
    "global.ingress.tls.enabled" : false,
    "global.minio.enabled" : true,
    "externalUrl" : "http://gitlab.code4beers.me",
    "gitlab-runner.rbac.create" : true,
    "gitlab-runner.rbac.clusterWideAccess" : true,
  }
}

variable "node_selector" {
  type = map(any)
  default = {
    "InstanceType" = "x86",
    # "eks.amazonaws.com/capacityType" = "ON_DEMAND",
  }
}

variable "ingress_annotations" {
  type    = map(any)
  default = {}
}
