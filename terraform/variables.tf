variable "cluster_name" {
  default     = "eks-fsx-netapp-ontap-patterns"
  description = "Name of the EKS Cluster"
}

variable "cluster_version" {
  default     = 1.27
  description = "EKS  Version"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default = "us-east-1"
  description = "aws region"
}

variable "fsx_name" {
  default     = "eks-fsx-cluster"
  description = "default fsx name"
}

variable "fsx_admin_password" {
  default     = "Netapp1!"
  description = "default fsx filesystem admin password"
}

variable "argocd_secret_manager_name_suffix" {
  type        = string
  description = "Name of secret manager secret for ArgoCD Admin UI Password"
  default     = "argocd-admin-secret"
}