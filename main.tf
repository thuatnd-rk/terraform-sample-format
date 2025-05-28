terraform {
  backend "s3" {}
}

# Define local variables for the project
# This section defines local variables that are used throughout the Terraform configuration.
locals {
  project_name = "cagent-vib"
  environment  = "prod"
  
  # General tags
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    Terraform   = "True"
    Owner       = "CTS-DevOps-Team"
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }
  
  # Create lowercase version of project name for S3 bucket
  project_name_lowercase = lower(replace(local.project_name, " ", "-"))

  # Name for resources
  knowledge_base_name = "${local.project_name}-knowledge-base"
  ec2_name = "${local.project_name}-server"
  vpc_name     = "${local.project_name}-vpc"
  keypair_name = "${local.project_name}-keypair"
  s3_bucket_name = "${local.project_name_lowercase}-docs"
}

# VPC
module "vpc" {
  source     = "./modules/vpc"
  vpc_config = merge(var.vpc_config,{
    name = local.vpc_name
    tags = merge(var.vpc_config.tags, local.common_tags)
  })
  
  depends_on = [
    module.bedrock_knowledge_base,
    module.opensearch_serverless
  ]
}

# AMI
module "ami" {
  source = "./modules/ami"
}

# Security Group
module "sg" {
  source                    = "./modules/sg"
  vpc_id                    = module.vpc.vpc_id
  depends_on                = [module.vpc]
}

# EC2
module "ec2" {
  source                    = "./modules/ec2"
  ec2_instance_config       = merge(var.ec2_instance_config,{
    name = local.ec2_name
    tags = merge(var.ec2_instance_config.tags, local.common_tags)
  })
  ami_id                    = module.ami.ubuntu_ami_id
  iam_instance_profile      = module.iam.cagent_server_role_name
  subnets                   = module.vpc.private_subnets[0]
  security_group_ids        = module.sg.cagent_server_sg_id
  depends_on                = [module.sg, module.iam, module.vpc]
}

# IAM Role
module "iam" {
  source = "./modules/iam"

  iam_config = merge(
    var.iam_config,
    {
      bedrock_knowledge_base = merge(
        var.iam_config.bedrock_knowledge_base,
        {
          opensearch_collection_arn = module.opensearch_serverless.opensearch_collection_arn
          s3_bucket_arn             = module.s3.s3_bucket_arn
        }
      )
    }
  )
}

# ALB
module "alb" {
  source = "./modules/alb"
  
  name = "${local.project_name}-alb"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_group_ids = [module.sg.alb_sg_id]
  
  alb_config = merge(var.alb_config, {
    target_groups = {
      for k, v in var.alb_config.target_groups : k => merge(v, {
        vpc_id    = module.vpc.vpc_id
        target_id = module.ec2.ec2_instance_id
      })
    }
  })
  
  depends_on = [module.vpc, module.sg, module.ec2]
}

# S3 Bucket
module "s3" {
  source                    = "./modules/s3"
  s3_bucket_config          = merge(var.s3_bucket_config, {
    bucket = local.s3_bucket_name
    tags = merge(var.s3_bucket_config.tags, local.common_tags)
  })
}

# OpenSearch Serverless - OSS
module "opensearch_serverless" {
  source                    = "./modules/opensearch_serverless"
  bedrock_knowledge_base_role_arn               = module.iam.bedrock_knowledge_base_role_arn
  opensearch_collection_name            = var.opensearch_collection_name
  opensearch_index_config = var.opensearch_index_config
}

# Bedrock Knowledge Base
module "bedrock_knowledge_base" {
  source = "./modules/bedrock"

  knowledge_base_config = merge(
    var.knowledge_base_config,
    {
      name                    = local.knowledge_base_name
      bedrock_knowledge_base_role_arn                  = module.iam.bedrock_knowledge_base_role_arn
      opensearch_collection_arn = module.opensearch_serverless.opensearch_collection_arn
      vector_index_name         = module.opensearch_serverless.vector_index_name
      tags = merge(var.knowledge_base_config.tags, local.common_tags)
    }
  )

  data_source_config = merge(
    var.data_source_config,
    {
      bucket_arn = module.s3.s3_bucket_arn
    }
  )

  parsing_configuration = var.parsing_configuration
  chunking_configuration = var.chunking_configuration
  depends_on = [module.opensearch_serverless]
}




