
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "argocd_secret_manager_name_suffix" {
  type        = string
  description = "Name of secret manager secret for ArgoCD Admin UI Password"
  default     = "argocd-admin-secret"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "eks-fsx-cluster"
}

variable "fsx_name" {
  default     = "eks-fsx-cluster"
  description = "default fsx name"
}