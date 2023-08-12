locals {

  cluster_name = var.cluster_name
  cluster_version            = var.cluster_version
  
  vpc_cidr       = var.vpc_cidr
  num_of_subnets = min(length(data.aws_availability_zones.available.names), 2)
  azs            = slice(data.aws_availability_zones.available.names, 0, local.num_of_subnets)
  
  argocd_secret_manager_name = var.argocd_secret_manager_name_suffix
 
  addons_repo_url            = var.addons_repo_url

#---------------------------------------------------------------
  # ARGOCD ADD-ON APPLICATION
  #---------------------------------------------------------------

  #At this time (with new v5 addon repository), the Addons need to be managed by Terrform and not ArgoCD
  addons_application = {
    path                = "chart"
    repo_url            = local.addons_repo_url
    add_on_application  = true
  }


}

