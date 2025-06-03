module "s3" {
  source = "./modules/amazon_s3"

  bucket_name_prefix = var.bucket_name_prefix
}

module "lambda" {
  source                    = "./modules/lambda"
  function_name             = var.function_name
  handler                   = var.handler
  runtime                   = var.runtime
  lambda_zip                = "${path.module}/build/lambda.zip"
  s3_bucket                 = module.s3.bucket_name
  enable_eventbridge_trigger = var.enable_eventbridge_trigger
  schedule_expression       = var.schedule_expression
}

module "api_gateway" {
  source = "./modules/api_gw"

  lambda_function_arn = module.lambda.lambda_arn
}
