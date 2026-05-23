# PowerShell script for Windows users

$ENDPOINT_URL = "http://localhost:4566"
$FUNCTION_NAME = "my-python-function"
$ROLE_ARN = "arn:aws:iam::000000000000:role/lambda-role"
$HANDLER = "lambda_handler.lambda_handler"
$RUNTIME = "python3.9"
$ZIP_FILE = "lambda_function.zip"

# Wait for LocalStack to be ready
Write-Host "Waiting for LocalStack to be ready..."
Start-Sleep -Seconds 10

# Create IAM role
Write-Host "Creating IAM role..."
aws --endpoint-url=$ENDPOINT_URL iam create-role `
  --role-name lambda-role `
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
  }' 2>$null | Out-Null

Write-Host "Role created or already exists"

# Create deployment package
Write-Host "Creating Lambda deployment package..."
if (Test-Path $ZIP_FILE) {
    Remove-Item $ZIP_FILE
}
Compress-Archive -Path lambda_handler.py -DestinationPath $ZIP_FILE

# Create Lambda function
Write-Host "Creating Lambda function..."
aws --endpoint-url=$ENDPOINT_URL lambda create-function `
  --function-name $FUNCTION_NAME `
  --role $ROLE_ARN `
  --handler $HANDLER `
  --runtime $RUNTIME `
  --zip-file fileb://$ZIP_FILE `
  --region us-east-1

Write-Host "Lambda function deployed successfully!"
Write-Host ""
Write-Host "Test the function with:"
Write-Host "aws --endpoint-url=$ENDPOINT_URL lambda invoke --function-name $FUNCTION_NAME --payload '{`"test`": `"data`"}' response.json"
