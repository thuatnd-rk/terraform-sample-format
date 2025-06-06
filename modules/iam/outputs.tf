output "example_server_role_name" {
  value = aws_iam_instance_profile.example_server_profile.name
}

output "bedrock_knowledge_base_role_arn" {
  value = aws_iam_role.bedrock_knowledge_base_role.arn
}