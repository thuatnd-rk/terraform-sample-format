variable "bedrock_knowledge_base_role_arn" {
  description = "ARN of the Bedrock knowledge base role"
  type        = string
}

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
