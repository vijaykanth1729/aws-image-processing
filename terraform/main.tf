resource "aws_s3_bucket" "raw_bucket" {
  bucket = "raw-images-bucket"
}

resource "aws_s3_bucket" "processed_bucket" {
  bucket = "processed-images-bucket"
}

resource "aws_lambda_function" "image_processor" {
  function_name = "ImageProcessor"
  role          = "arn:aws:iam::ACCOUNT_ID:role/LambdaS3Role"
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  filename      = "lambda_function.zip"
  timeout       = 30
}

