output "rest_api_id" {
  value       = aws_apigatewayv2_api.this.id
  description = "API Gateway REST API ID"
}
