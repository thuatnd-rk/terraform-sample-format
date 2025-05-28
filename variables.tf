# Region
variable "region" {
  type        = string
  description = "AWS region to deploy the resources"
}

# VPC Configuration
variable "vpc_config" {
  description = "Configuration for the VPC module"
  type = object({
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

# EC2
variable "ec2_instance_config" {
  description = "Configuration for the EC2 instance module"
  type = object({
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

# IAM Role
variable "iam_config" {
  description = "IAM config for EC2 and Bedrock Agent roles"
  type = object({
    ec2_access = object({
      role_name        = string
      instance_profile = string
    })
    bedrock_knowledge_base = object({
      role_name             = string
      foundation_model_arns = list(string)
    })
  })
}

# S3 bucket
variable "s3_bucket_config" {
  description = "Configuration for the S3 bucket module"
  type = object({
    control_object_ownership     = bool
    force_destroy                = bool
    versioning                   = object({
      enabled = bool
    })
    tags                         = map(string)
  })
}

# OpenSearch Serverless
variable "opensearch_collection_name" {
  description = "Name of the OpenSearch collection"
  type        = string
}

variable "opensearch_index_config" {
  description = "Configuration for the OpenSearch index"
  type = object({
    name                           = string
    number_of_shards               = string
    number_of_replicas             = string
    index_knn                      = bool
    index_knn_algo_param_ef_search = string
    force_destroy                  = bool
    mappings                       = string
  })
}

# Bedrock
variable "knowledge_base_config" {
  description = "Configuration for Bedrock Knowledge Base"
  type = object({
    embedding_model_arn       = string
    vector_field              = string
    text_field                = string
    metadata_field            = string
    tags                     = map(string)
  })
}

variable "data_source_config" {
  description = "Configuration object for Bedrock Data Source"
  type = object({
    name       = string
  })
}

variable "parsing_configuration" {
  description = "Parsing configuration for the data source"
  type = object({
    model_arn             = string
    parsing_prompt_string = string
  })
}

variable "chunking_configuration" {
  description = "Chunking configuration for the data source"
  type = object({
    strategy                        = string
    max_token                       = number
    breakpoint_percentile_threshold = number
    buffer_size                     = number
  })
}

# ALB Configuration
variable "alb_config" {
  description = "Configuration for the ALB module"
  type = object({
    internal    = optional(bool, false)
    load_balancer_type = optional(string, "application")
    
    # Listener configurations
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