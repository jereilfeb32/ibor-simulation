variable "api_name" {
  type        = string
  description = "API Gateway name"
  default     = "pricing_api"
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function to integrate"
}
