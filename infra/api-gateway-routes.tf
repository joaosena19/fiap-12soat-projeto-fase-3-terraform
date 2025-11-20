# ========== Rotas sem autenticação JWT ==========

# Rota POST /auth/login (sem autenticação JWT) - Lambda
resource "aws_apigatewayv2_route" "auth_login" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /auth/login"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_auth.id}"
}

# Rota POST /api/ordens-servico/busca-publica (sem autenticação JWT) - EKS
resource "aws_apigatewayv2_route" "busca_publica" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /api/ordens-servico/busca-publica"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

# Rotas de webhook (sem autenticação JWT) - EKS
resource "aws_apigatewayv2_route" "webhooks" {
  for_each = toset([
    "POST /api/ordens-servico/orcamento/aprovar/webhook",
    "POST /api/ordens-servico/orcamento/desaprovar/webhook",
    "POST /api/ordens-servico/status/webhook"
  ])

  api_id    = aws_apigatewayv2_api.main.id
  route_key = each.value
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

# ========== Rotas com autenticação JWT ==========

# Rota catch-all para EKS (todas as rotas protegidas)
resource "aws_apigatewayv2_route" "eks_proxy" {
  api_id             = aws_apigatewayv2_api.main.id
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.eks.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}
