output "cagent_server_sg_id" {
  value = aws_security_group.cagent_server_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}