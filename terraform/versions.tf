
terraform {

  required_version = ">= 1.4.0"
  
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.22.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.12.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }   
  }
}
