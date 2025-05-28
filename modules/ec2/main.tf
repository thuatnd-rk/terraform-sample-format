module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.8.0"

  name = var.ec2_instance_config.name
  ami           = var.ami_id
  iam_instance_profile      = var.iam_instance_profile
  subnet_id                 = var.subnets
  vpc_security_group_ids    = [var.security_group_ids]
  instance_type             = var.ec2_instance_config.instance_type
  monitoring                = var.ec2_instance_config.monitoring
  associate_public_ip_address = var.ec2_instance_config.associate_public_ip_address
  root_block_device         = var.ec2_instance_config.root_block_device
  tags                      = var.ec2_instance_config.tags
}


