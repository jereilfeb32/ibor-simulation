bucket_name_prefix          = "ibors3pricing"
function_name               = "ibor-lmb-simulator"
handler                     = "lambda_function.lambda_handler"
runtime                     = "python3.9"
enable_eventbridge_trigger  = true
schedule_expression         = "rate(1 day)"
aws_region = "ap-southeast-1"
