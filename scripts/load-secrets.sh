#!/bin/bash
set -e

echo "Loading secrets using environment variable references..."

# Get database credentials from Secrets Manager using the environment variable
if [ -n "$SECRETS_MANAGER_SECRET_ID" ]; then
  DB_CREDS=$(aws secretsmanager get-secret-value --secret-id $SECRETS_MANAGER_SECRET_ID --query SecretString --output text)

  # Parse JSON and export as environment variables
  export DB_USERNAME=$(echo $DB_CREDS | jq -r '.DATABASE_USERNAME')
  export DB_PASSWORD=$(echo $DB_CREDS | jq -r '.DATABASE_PASSWORD')

  echo "Credentials loaded successfully from Secrets Manager"
else
  echo "No Secrets Manager secret ID provided"
fi

# Parameter Store values are automatically loaded by CodeBuild for environment variables
# of type PARAMETER_STORE, but we'll log their presence for clarity
if [ -n "$PARAMETER_STORE_DB_ENDPOINT" ]; then
  echo "Using database endpoint from Parameter Store: $PARAMETER_STORE_DB_ENDPOINT"
else
  echo "No database endpoint provided via Parameter Store"
fi

if [ -n "$API_KEY_PARAMETER" ]; then
  echo "API key has been loaded from Parameter Store"
else
  echo "No API key provided via Parameter Store"
fi

# Mask sensitive values from logs
echo "::add-mask::$DB_PASSWORD"
echo "::add-mask::$API_KEY_PARAMETER"
