variable "bucket_name_prefix" {
  type        = string
  description = "Prefix for the S3 bucket name"
  default     = "myapp-bucket"
}

variable "function_name" {
  type        = string
  description = "Lambda function name"
  default     = "my_lambda_function"
}

variable "handler" {
  type        = string
  description = "Lambda function handler"
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime"
  default     = "python3.9"
}

variable "enable_eventbridge_trigger" {
  type        = bool
  description = "Enable EventBridge scheduled trigger"
  default     = true
}

variable "schedule_expression" {
  type        = string
  description = "Schedule expression for EventBridge (e.g., cron or rate)"
  default     = "rate(1 day)"
}

variable "aws_region" {
    
  
}
