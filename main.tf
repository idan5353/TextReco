provider "aws" {
  region = "us-west-2" # שנה לפי האזור שלך
}

resource "aws_s3_bucket" "ocr_bucket" {
  bucket = "my-images-bucket535"
}

resource "aws_dynamodb_table" "ocr_results" {
  name         = "OCRResults"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "image_name"

  attribute {
    name = "image_name"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_ocr_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_ocr_policy"
  description = "Policy for Lambda to access S3, Textract, and DynamoDB"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-images-bucket535/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "textract:DetectDocumentText"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "arn:aws:dynamodb:us-west-2:*:table/OCRResults"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-images-bucket535/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "ocr_lambda" {
  function_name    = "ProcessOCR"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  filename         = "lambda_function.zip" # העלה קובץ ZIP עם הקוד
}

resource "aws_lambda_permission" "allow_s3_trigger" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ocr_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.ocr_bucket.arn
}

resource "aws_s3_bucket_notification" "s3_lambda_trigger" {
  bucket = aws_s3_bucket.ocr_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.ocr_lambda.arn
    events              = ["s3:ObjectCreated:Put"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3_trigger
  ]
}
