#!/bin/bash
set -e

echo "Loading secrets into environment..."

# Get database credentials from Secrets Manager
DB_CREDS=$(aws secretsmanager get-secret-value --secret-id /prod/myapp/database-credentials --query SecretString --output text)

# Parse JSON and export as environment variables
export DB_USERNAME=$(echo $DB_CREDS | jq -r '.DATABASE_USERNAME')
export DB_PASSWORD=$(echo $DB_CREDS | jq -r '.DATABASE_PASSWORD')

# Get configuration from Parameter Store
export DB_ENDPOINT=$(aws ssm get-parameter --name "/prod/myapp/database-endpoint" --query Parameter.Value --output text)
export API_KEY=$(aws ssm get-parameter --name "/prod/myapp/api-key" --with-decryption --query Parameter.Value --output text)

# Log success but NEVER print the actual values
echo "Credentials and configuration loaded successfully"
echo "Using database endpoint: $DB_ENDPOINT"
echo "Loaded username: $DB_USERNAME"
echo "API key has been loaded"

# Mask environment variables from build logs
echo "::add-mask::$DB_PASSWORD"
echo "::add-mask::$API_KEY"
