iam_config = {
  ec2_access = {
    role_name        = "exampleServerRole"
    instance_profile = "instance-profile-bedrock"
  }
 
  bedrock_knowledge_base = {
    role_name             = "exampleBedrockRole"
    foundation_model_arns = [
      "arn:aws:bedrock:us-west-2::foundation-model/cohere.embed-multilingual-v3",
      "arn:aws:bedrock:us-west-2::foundation-model/anthropic.claude-3-haiku-20240307-v1:0",
      "arn:aws:bedrock:us-west-2::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0"
    ]
  }
}
