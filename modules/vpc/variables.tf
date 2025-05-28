variable "vpc_config" {
  description = "Configuration for the VPC module"
  type = object({
    name                = string
    cidr                = string
    map_public_ip_on_launch = bool
    azs                 = list(string)
    private_subnets     = list(string)
    public_subnets      = list(string)
    enable_nat_gateway  = bool
    single_nat_gateway  = bool
    enable_vpn_gateway  = bool
    tags                = map(string)
  })
}
