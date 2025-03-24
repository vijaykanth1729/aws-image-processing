# AWS Image Processing

This project is an AWS Lambda function that processes images from an S3 bucket using Python and Terraform.

## Structure
-  lambda_function.py - AWS Lambda function
- requirements.txt - Python dependencies
- terraform/ - Terraform code for AWS infrastructure

## Deployment Steps

Next Steps
1) Ensure lambda.zip is available before applying Terraform
      **zip lambda.zip lambda_function.py**

2) Deploy with Terraform
         **terraform init
         terraform apply -auto-approve**

