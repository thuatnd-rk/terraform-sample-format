module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name                  = var.vpc_config.name
  cidr                  = var.vpc_config.cidr
  azs                   = var.vpc_config.azs
  private_subnets       = var.vpc_config.private_subnets
  public_subnets        = var.vpc_config.public_subnets
  enable_nat_gateway    = var.vpc_config.enable_nat_gateway
  single_nat_gateway    = var.vpc_config.single_nat_gateway
  enable_vpn_gateway    = var.vpc_config.enable_vpn_gateway
  map_public_ip_on_launch = var.vpc_config.map_public_ip_on_launch
  tags = var.vpc_config.tags
}
