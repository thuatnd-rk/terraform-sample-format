module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.16.0"

  name    = var.name  
  vpc_id  = var.vpc_id
  subnets = var.subnets
  security_groups = var.security_group_ids

  # Listeners and target groups from config
  listeners    = var.alb_config.listeners
  target_groups = var.alb_config.target_groups
  enable_deletion_protection = var.alb_config.enable_deletion_protection

  tags = var.alb_config.tags
}