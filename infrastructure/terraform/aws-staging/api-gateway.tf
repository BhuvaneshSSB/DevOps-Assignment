# Path: infrastructure/terraform/aws-dev/api-gateway.tf

resource "aws_api_gateway_rest_api" "backend" {
  name        = "${var.app_name}-backend-${var.environment}"
  description = "API Gateway for ${var.app_name} backend"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = "${var.app_name}-backend-api"
  }
}

resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.backend.id
  parent_id   = aws_api_gateway_rest_api.backend.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "api_proxy" {
  rest_api_id = aws_api_gateway_rest_api.backend.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_proxy_method" {
  rest_api_id      = aws_api_gateway_rest_api.backend.id
  resource_id      = aws_api_gateway_resource.api_proxy.id
  http_method      = "ANY"
  authorization    = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_proxy_integration" {
  rest_api_id      = aws_api_gateway_rest_api.backend.id
  resource_id      = aws_api_gateway_resource.api_proxy.id
  http_method      = aws_api_gateway_method.api_proxy_method.http_method
  type             = "HTTP_PROXY"
  uri              = "http://${aws_lb.main.dns_name}:8000/api/{proxy}"
  integration_http_method = "ANY"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "backend" {
  depends_on = [
    aws_api_gateway_integration.api_proxy_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.backend.id
}

resource "aws_api_gateway_stage" "backend" {
  deployment_id = aws_api_gateway_deployment.backend.id
  rest_api_id   = aws_api_gateway_rest_api.backend.id
  stage_name    = var.environment

  tags = {
    Name = "${var.app_name}-backend-stage-${var.environment}"
  }
}

output "api_gateway_url" {
  value = aws_api_gateway_stage.backend.invoke_url
}

output "api_gateway_endpoint" {
  value = "${aws_api_gateway_stage.backend.invoke_url}/api"
}