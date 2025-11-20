# Data source para obter ARN e nome da Lambda do remote state
data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.lambda_terraform_state_bucket
    key    = var.lambda_terraform_state_key
    region = var.aws_region
  }
}

# API Gateway HTTP API
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_identifier}-api-gateway"
  protocol_type = "HTTP"
  description   = "API Gateway para roteamento entre Lambda (auth) e EKS (aplicação)"

  cors_configuration {
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"]
    allow_headers     = ["content-type", "authorization", "x-api-key"]
    expose_headers    = ["content-type"]
    max_age          = 3600
  }

  tags = {
    Name = "${var.project_identifier}-api-gateway"
  }
}

# Stage padrão
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true

  tags = {
    Name = "${var.project_identifier}-api-gateway-stage"
  }
}

# Permissão para API Gateway invocar a Lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.lambda.outputs.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

# Integração com Lambda
resource "aws_apigatewayv2_integration" "lambda_auth" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "AWS_PROXY"
  integration_uri    = data.terraform_remote_state.lambda.outputs.lambda_function_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

# JWT Authorizer para validar tokens nas rotas protegidas
resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id           = aws_apigatewayv2_api.main.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "${var.project_identifier}-jwt-authorizer"

  jwt_configuration {
    audience = [var.jwt_audience]
    issuer   = var.jwt_issuer
  }
}

# Security Group para VPC Link
resource "aws_security_group" "vpc_link_sg" {
  name        = "${var.project_identifier}-vpc-link-sg"
  description = "Security group para VPC Link do API Gateway"
  vpc_id      = aws_vpc.vpc_principal.id

  egress {
    description = "Permitir todo tráfego de saída"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_identifier}-vpc-link-sg"
  }
}

# VPC Link para conectar API Gateway ao NLB privado
resource "aws_apigatewayv2_vpc_link" "eks" {
  name               = "${var.project_identifier}-vpc-link"
  security_group_ids = [aws_security_group.vpc_link_sg.id]
  subnet_ids         = aws_subnet.subnet_publica[*].id

  tags = {
    Name = "${var.project_identifier}-vpc-link"
  }
}

# Integração com EKS via VPC Link/NLB
resource "aws_apigatewayv2_integration" "eks" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = aws_lb_listener.eks_listener.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.eks.id
  payload_format_version = "1.0"
}
