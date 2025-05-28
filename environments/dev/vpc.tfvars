vpc_config = {
  cidr                = "172.16.0.0/16"
  azs                 = ["us-west-2a", "us-west-2b"]
  private_subnets     = ["172.16.0.0/24", "172.16.1.0/24"]
  public_subnets      = ["172.16.10.0/24", "172.16.11.0/24"]
  map_public_ip_on_launch = false
  enable_nat_gateway  = true
  single_nat_gateway  = true
  enable_vpn_gateway  = false
  tags = {}
}