locals {
  main_tags = {
    Environment = "preprod"
    Project     = "omega"
    Component   = "network"
    IaaC        = "terraform"
  }
}


############
## VPC
############
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  
  name = "omega-preprod"
  cidr = "10.0.0.0/16"

  # public_subnets used for ECS ec2 instance
  # intra_subnets used for RDS
  enable_nat_gateway = false
  azs             = ["eu-north-1a", "eu-north-1b"]
  intra_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # IPv6 Configuration
  enable_ipv6 = true
  public_subnet_ipv6_prefixes  = [0, 1]  # Assign IPv6 CIDRs from AWS's pool

  # Intra subnet settings (remain IPv4-only)
  intra_subnet_assign_ipv6_address_on_creation = false
  intra_subnet_enable_dns64 = false
  intra_subnet_enable_resource_name_dns_aaaa_record_on_launch = false

  # Other necessary settings
  manage_default_security_group = false
  enable_dns_hostnames = true

  tags = local.main_tags
}
