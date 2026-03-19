data "aws_availability_zones" "available" {
    filter {
      name = "opt-in-status"
      values = [ "opt-in-not-required" ]
    }
}

locals {
  azs = slice(data.aws_availability_zones.available.names,0,3)
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "${var.cluster_name}-vpc"
    cidr = var.vpc_cidr

    azs = local.azs
    private_subnets = [for k,v in local.azs : cidrsubnet(var.vpc_cidr,4,k)]
    public_subnets = [for k,v in local.azs : cidrsubnet(var.vpc_cidr,8,k+48)]

    enable_nat_gateway = true

    single_nat_gateway = true
  
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 21.0"

    name = var.cluster_name
    kubernetes_version = var.cluster_version

    compute_config = {
        enabled = true
        node_pools = ["general-purpose","system"]
    }

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    enable_cluster_creator_admin_permissions = true

    endpoint_private_access = true
    endpoint_public_access = true
  
}