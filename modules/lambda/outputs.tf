output "eventbridge_rule_name" {
  value       = var.enable_eventbridge_trigger ? aws_cloudwatch_event_rule.daily_trigger[0].name : null
  description = "Name of the EventBridge rule triggering the Lambda"
}
