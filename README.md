# AWS Image Processing

This project is an AWS Lambda function that processes images from an S3 bucket using Python and Terraform.

## Structure
-  lambda_function.py - AWS Lambda function
- requirements.txt - Python dependencies
- terraform/ - Terraform code for AWS infrastructure

## Deployment Steps
1. Install dependencies:
   ```sh
   pip install -r requirements.txt -t .
   zip -r lambda_function.zip ./*

