# Path: infrastructure/terraform/aws-dev/http-api-gateway.tf

# HTTP API Gateway for HTTPS endpoint
resource "aws_apigatewayv2_api" "backend" {
  name          = "${var.app_name}-api-${var.environment}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }

  tags = {
    Name = "${var.app_name}-api"
  }
}

# API Gateway Integration with ALB
resource "aws_apigatewayv2_integration" "alb" {
  api_id             = aws_apigatewayv2_api.backend.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = "http://${aws_lb.main.dns_name}"
  payload_format_version = "1.0"
}

# Default Route - catches all requests
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.backend.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.alb.id}"
}

# API Gateway Stage (HTTPS endpoint)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.backend.id
  name        = var.environment
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      requestId          = "$context.requestId"
      ip                 = "$context.identity.sourceIp"
      requestTime        = "$context.requestTime"
      httpMethod         = "$context.httpMethod"
      resourcePath       = "$context.resourcePath"
      status             = "$context.status"
      protocol           = "$context.protocol"
      responseLength     = "$context.responseLength"
      integrationLatency = "$context.integration.latency"
    })
  }

  tags = {
    Name = "${var.app_name}-api-stage"
  }
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/apigateway/${var.app_name}-${var.environment}"
  retention_in_days = 7

  tags = {
    Name = "${var.app_name}-api-logs"
  }
}

output "api_gateway_invoke_url" {
  description = "API Gateway HTTPS endpoint"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = aws_apigatewayv2_api.backend.id
}
