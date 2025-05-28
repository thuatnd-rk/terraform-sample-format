variable "ec2_instance_config" {
  description = "Configuration for the EC2 instance module"
  type = object({
    name                    = string
    instance_type             = string
    monitoring                = bool
    associate_public_ip_address = bool
    root_block_device         = list(object({
      encrypted    = bool
      volume_type  = string
      throughput   = number
      volume_size  = number
    }))
    tags = map(string)
  })
}

variable "security_group_ids" {
    description = "Security groups"
    type        = string
}

variable "subnets" {
    description = "Subnets"
    type        = string
}

variable "iam_instance_profile" {
    description = "Instance profile"
    type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}