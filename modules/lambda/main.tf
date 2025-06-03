resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# New IAM Policy to allow Lambda to PutObject in S3 bucket
resource "aws_iam_policy" "lambda_s3_put_policy" {
  name = "${var.function_name}-s3-put-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_put_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_s3_put_policy.arn
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  filename      = var.lambda_zip
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_exec.arn

  timeout     = 60      # Timeout increased to 60 seconds
  memory_size = 1024    # Memory increased to 1024 MB

  environment {
    variables = {
      S3_BUCKET = var.s3_bucket
    }
  }
}

# EventBridge trigger (optional)
resource "aws_cloudwatch_event_rule" "daily_trigger" {
  count              = var.enable_eventbridge_trigger ? 1 : 0
  name               = "${var.function_name}-daily-trigger"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  count      = var.enable_eventbridge_trigger ? 1 : 0
  rule       = aws_cloudwatch_event_rule.daily_trigger[0].name
  target_id  = "lambda"
  arn        = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  count        = var.enable_eventbridge_trigger ? 1 : 0
  statement_id = "AllowExecutionFromEventBridge"
  action       = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal    = "events.amazonaws.com"
  source_arn   = aws_cloudwatch_event_rule.daily_trigger[0].arn
}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}
