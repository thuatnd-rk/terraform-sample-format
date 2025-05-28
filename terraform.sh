#!/bin/bash

# Usage: ./terraform.sh [env] [action]
# Example: ./terraform.sh prod apply

set -e

ENV=$1
ACTION=$2

if [[ -z "$ENV" || -z "$ACTION" ]]; then
  echo "Usage: ./terraform.sh [dev|prod] [plan|apply|destroy]"
  exit 1
fi

REGION_VARS="environments/$ENV/region.tfvars"
VPC_VARS="environments/$ENV/vpc.tfvars"
EC2_VARS="environments/$ENV/ec2.tfvars"
IAM_VARS="environments/$ENV/iam.tfvars"
ALB_VARS="environments/$ENV/alb.tfvars"
S3_VARS="environments/$ENV/s3.tfvars"
OPENSEARCH_SERVERLESS_VARS="environments/$ENV/opensearch_serverless.tfvars"
BEDROCK_VARS="environments/$ENV/bedrock.tfvars"
BACKEND_CONFIG="environments/$ENV/backend.config"


echo ">>> Initializing Terraform with backend config from $BACKEND_CONFIG..."
terraform init -backend-config="$BACKEND_CONFIG"

echo ">>> Running 'terraform $ACTION' with tfvars from $REGION_VARS $VPC_VARS, $EC2_VARS, $IAM_VARS, $ALB_VARS, $S3_VARS, $OPENSEARCH_SERVERLESS_VARS, $BEDROCK_VARS..."
terraform "$ACTION" \
  -var-file="$REGION_VARS" \
  -var-file="$VPC_VARS" \
  -var-file="$EC2_VARS" \
  -var-file="$ALB_VARS" \
  -var-file="$S3_VARS" \
  -var-file="$OPENSEARCH_SERVERLESS_VARS" \
  -var-file="$BEDROCK_VARS" \
  -var-file="$IAM_VARS" \