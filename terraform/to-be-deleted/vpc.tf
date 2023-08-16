
data "aws_availability_zones" "available" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0.0"

  name = local.cluster_name
  cidr = local.vpc_cidr
  azs  = local.azs 

  private_subnets   = ["10.0.0.0/28", "10.0.0.16/28"]
  public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets  = ["10.0.64.0/18", "10.0.128.0/18"]
  
  enable_nat_gateway   = true
  single_nat_gateway   = false
  one_nat_gateway_per_az = true

  create_igw           = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_dhcp_options  = true
  
    # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  

  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.cluster_name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.cluster_name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.cluster_name}-default" }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  database_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

}
