#!/bin/bash

# LocalStack configuration
ENDPOINT_URL="http://localhost:4566"
FUNCTION_NAME="my-python-function"
ROLE_ARN="arn:aws:iam::000000000000:role/lambda-role"
HANDLER="lambda_handler.lambda_handler"
RUNTIME="python3.9"
ZIP_FILE="lambda_function.zip"

# Wait for LocalStack to be ready
echo "Waiting for LocalStack to be ready..."
sleep 10

# Create IAM role (required for Lambda)
echo "Creating IAM role..."
aws --endpoint-url=$ENDPOINT_URL iam create-role \
  --role-name lambda-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }' || echo "Role might already exist"

# Create deployment package
echo "Creating Lambda deployment package..."
zip -j $ZIP_FILE lambda_handler.py

# Create Lambda function
echo "Creating Lambda function..."
aws --endpoint-url=$ENDPOINT_URL lambda create-function \
  --function-name $FUNCTION_NAME \
  --role $ROLE_ARN \
  --handler $HANDLER \
  --runtime $RUNTIME \
  --zip-file fileb://$ZIP_FILE \
  --region us-east-1

echo "Lambda function deployed successfully!"
echo ""
echo "Test the function with:"
echo "aws --endpoint-url=$ENDPOINT_URL lambda invoke --function-name $FUNCTION_NAME --payload '{\"test\": \"data\"}' response.json && cat response.json"
