variable "function_name" {
  type        = string
  description = "Lambda function name"
}

variable "handler" {
  type        = string
  description = "Lambda handler"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime"
}

variable "lambda_zip" {
  type        = string
  description = "Path to Lambda zip file"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket name"
}

variable "enable_eventbridge_trigger" {
  type        = bool
  description = "Whether to enable EventBridge trigger"
  default     = false
}

variable "schedule_expression" {
  type        = string
  description = "Schedule expression for EventBridge"
  default     = ""
}
