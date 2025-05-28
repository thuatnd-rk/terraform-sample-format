variable "alb_config" {
  description = "Configuration for the ALB module"
  type = object({
    internal    = optional(bool, false)
    load_balancer_type = optional(string, "application")
    
    # Listener configurations - accepts a single object with any structure
    listeners = any 

    # Target group configurations
    target_groups = map(object({
      name_prefix      = string
      protocol         = string
      port             = number
      target_type      = string
      target_id        = optional(string)
      vpc_id           = optional(string)
      
      health_check = optional(object({
        enabled             = bool
        interval           = number
        path              = string
        port              = string
        healthy_threshold   = number
        unhealthy_threshold = number
        timeout           = number
        protocol          = string
        matcher           = string
      }))
      
      stickiness = optional(object({
        type            = string
        cookie_duration = optional(number)
        enabled         = optional(bool)
      }))
    }))
    
    enable_deletion_protection = optional(bool, false)
    tags = optional(map(string))
  })
}

# Variables that can be passed from other modules
variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs where the ALB will be created"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the ALB"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "Name of the ALB"
  type        = string
} 