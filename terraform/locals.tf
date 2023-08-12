locals {

  cluster_name = var.cluster_name
  cluster_version            = var.cluster_version
  
  vpc_cidr       = var.vpc_cidr
  num_of_subnets = min(length(data.aws_availability_zones.available.names), 2)
  azs            = slice(data.aws_availability_zones.available.names, 0, local.num_of_subnets)
  
  argocd_secret_manager_name = var.argocd_secret_manager_name_suffix

}

