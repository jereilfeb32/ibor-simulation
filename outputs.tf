output "eventbridge_rule_name" {
  value = module.lambda.eventbridge_rule_name
}

output "api_gateway_rest_api_id" {
  value = module.api_gateway.rest_api_id
}
