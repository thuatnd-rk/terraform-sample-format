output "alb_id" {
  description = "The ID of the ALB"
  value       = module.alb.id
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = module.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB"
  value       = module.alb.zone_id
}

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb.target_groups
}

output "listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb.listeners
} 
