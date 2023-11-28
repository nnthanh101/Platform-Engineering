variable "image_repo_url" {}

variable "metrics_server_enable" {
  type        = bool
  default     = true
  description = "Enabling metrics server on eks cluster"
}
variable "cluster_autoscaler_enable" {
  type        = bool
  default     = true
  description = "Enabling cluster autoscaler server on eks cluster"
}
variable "traefik_ingress_controller_enable" {
  type        = bool
  default     = false
  description = "Enabling Traefik Ingress on eks cluster"
}

variable "lb_ingress_controller_enable" {
  type        = bool
  default     = false
  description = "Enabling LB Ingress controller on eks cluster"
}

variable "aws_for_fluent_bit_enable" {
  type        = bool
  default     = false
  description = "Enabling aws_fluent_bit on eks cluster"
}

variable "fargate_fluent_bit_enable" {
  type        = bool
  default     = false
  description = "Enabling fargate_fluent_bit on eks cluster"
}

variable "fargate_iam_role" {}

variable "s3_nlb_logs" {
  description = "S3 bucket for NLB Logs"
}

variable "eks_cluster_id" {
  description = "EKS cluster Id"
}

variable "ekslog_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days."
}

variable "public_docker_repo" {}

variable "eks_oidc_issuer_url" {}

variable "eks_oidc_provider_arn" {}
