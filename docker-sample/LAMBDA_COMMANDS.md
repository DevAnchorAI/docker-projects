# Working AWS Lambda Commands for LocalStack

## Quick Start (Windows)

### 1. Start LocalStack and Flask app
```powershell
docker-compose up -d
```

### 2. Wait 15 seconds for LocalStack to initialize
```powershell
Start-Sleep -Seconds 15
```

### 3. Create IAM Role (one-time setup)
```powershell
aws --endpoint-url=http://localhost:4566 iam create-role `
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
  }' `
  --region us-east-1
```

### 4. Create Deployment Package
```powershell
Compress-Archive -Path lambda_handler.py -DestinationPath lambda_function.zip -Force
```

### 5. Create Lambda Function (Complete Command)
```powershell
aws --endpoint-url=http://localhost:4566 lambda create-function `
  --function-name my-python-function `
  --role arn:aws:iam::000000000000:role/lambda-role `
  --handler lambda_handler.lambda_handler `
  --runtime python3.9 `
  --zip-file fileb://lambda_function.zip `
  --region us-east-1
```

### 6. Invoke Lambda Function
```powershell
aws --endpoint-url=http://localhost:4566 lambda invoke `
  --function-name my-python-function `
  --payload '{"test": "data"}' `
  response.json `
  --region us-east-1

cat response.json
```

### 7. List Lambda Functions
```powershell
aws --endpoint-url=http://localhost:4566 lambda list-functions --region us-east-1
```

## Quick Start (Linux/Mac)

### 1. Start services
```bash
docker-compose up -d
```

### 2. Wait for LocalStack
```bash
sleep 15
```

### 3. Create IAM Role
```bash
aws --endpoint-url=http://localhost:4566 iam create-role \
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
  }' \
  --region us-east-1
```

### 4. Create Deployment Package
```bash
zip -j lambda_function.zip lambda_handler.py
```

### 5. Create Lambda Function (Complete Command)
```bash
aws --endpoint-url=http://localhost:4566 lambda create-function \
  --function-name my-python-function \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler lambda_handler.lambda_handler \
  --runtime python3.9 \
  --zip-file fileb://lambda_function.zip \
  --region us-east-1
```

### 6. Invoke Lambda Function
```bash
aws --endpoint-url=http://localhost:4566 lambda invoke \
  --function-name my-python-function \
  --payload '{"test": "data"}' \
  response.json \
  --region us-east-1

cat response.json
```

### 7. List Lambda Functions
```bash
aws --endpoint-url=http://localhost:4566 lambda list-functions --region us-east-1
```

## Use Deployment Scripts (Automated)

### Windows
```powershell
# Automatic deployment with all steps
.\deploy_lambda.ps1
```

### Linux/Mac
```bash
chmod +x deploy_lambda.sh
./deploy_lambda.sh
```

## Common Operations

### Update Lambda Code
```powershell
# After modifying lambda_handler.py
Compress-Archive -Path lambda_handler.py -DestinationPath lambda_function.zip -Force

aws --endpoint-url=http://localhost:4566 lambda update-function-code `
  --function-name my-python-function `
  --zip-file fileb://lambda_function.zip `
  --region us-east-1
```

### Delete Lambda Function
```powershell
aws --endpoint-url=http://localhost:4566 lambda delete-function `
  --function-name my-python-function `
  --region us-east-1
```

### Get Function Details
```powershell
aws --endpoint-url=http://localhost:4566 lambda get-function `
  --function-name my-python-function `
  --region us-east-1
```

## Troubleshooting

### LocalStack not responding
```powershell
# Check container is running
docker ps

# View LocalStack logs
docker logs <container-id>

# Test connection
Invoke-WebRequest -Uri 'http://localhost:4566' -UseBasicParsing
```

### Role already exists error
This is normal when deploying multiple times. The function creation will still work.

### Function already exists error
Delete and recreate:
```powershell
aws --endpoint-url=http://localhost:4566 lambda delete-function `
  --function-name my-python-function `
  --region us-east-1
```

## Files in this Project

- `app.py` — Flask web application
- `lambda_handler.py` — AWS Lambda function code
- `docker-compose.yml` — Containers: Flask app + LocalStack
- `requirements.txt` — Python dependencies
- `Dockerfile` — Container image for Flask
- `deploy_lambda.ps1` — Automated deployment script (Windows)
- `deploy_lambda.sh` — Automated deployment script (Linux/Mac)
