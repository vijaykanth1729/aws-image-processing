provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "raw_bucket" {
  bucket = "raw-images-bucket"
}

resource "aws_s3_bucket" "processed_bucket" {
  bucket = "processed-images-bucket"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "lambda_s3_policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_lambda_function" "image_processor" {
  function_name    = "ImageProcessor"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.8"
  handler          = "lambda_function.lambda_handler"
  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
  memory_size      = 512
  timeout          = 30
}

resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = aws_s3_bucket.raw_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw_bucket.arn
}
