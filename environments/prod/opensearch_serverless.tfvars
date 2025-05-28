opensearch_collection_name = "user-example"

opensearch_index_config = {
  name                           = "user-example-index"
  number_of_shards               = "2"
  number_of_replicas             = "0"
  index_knn                      = true
  index_knn_algo_param_ef_search = "512"
  force_destroy                  = true
  mappings = <<EOF
{
  "properties": {
    "bedrock-knowledge-base-default-vector": {
      "type": "knn_vector",
      "dimension": 1024,
      "method": {
        "name": "hnsw",
        "engine": "faiss",
        "parameters": {
          "m": 16,
          "ef_construction": 512
        },
        "space_type": "l2"
      }
    },
    "AMAZON_BEDROCK_METADATA": {
      "type": "text",
      "index": true
    },
    "AMAZON_BEDROCK_TEXT_CHUNK": {
      "type": "text",
      "index": true
    }
  }
}
EOF
}
