#!/usr/bin/env bash
set -euo pipefail

REGION="$1"

echo "🔐 Fetching EC2 IAM role credentials via IMDSv2..."

# Fetch temporary credentials from the EC2 instance metadata service (IMDSv2)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

ROLE_NAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/iam/security-credentials/)

CREDS=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/iam/security-credentials/${ROLE_NAME})

AWS_ACCESS_KEY_ID=$(echo "$CREDS" | jq -r .AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | jq -r .SecretAccessKey)
AWS_SESSION_TOKEN=$(echo "$CREDS" | jq -r .Token)

export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_REGION="$REGION"

# Export for GitHub Actions
{
  echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
  echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
  echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN"
  echo "AWS_REGION=$AWS_REGION"
} >> "$GITHUB_ENV"

echo "✅ AWS credentials exported to GITHUB_ENV"

# # 🐳 Login to Amazon ECR
# echo "🔐 Logging into Amazon ECR in region: $REGION"

# ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

# aws ecr get-login-password --region "$REGION" | \
#   docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

# echo "✅ Successfully logged into Amazon ECR"
