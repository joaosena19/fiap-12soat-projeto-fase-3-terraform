output "vpc_principal_cidr" {
  description = "Bloco CIDR da VPC principal"
  value       = aws_vpc.vpc_principal.cidr_block
}

output "vpc_principal_id" {
  description = "ID da VPC principal"
  value       = aws_vpc.vpc_principal.id
}

output "subnet_publica_cidrs" {
  description = "Blocos CIDR das subnets públicas"
  value       = aws_subnet.subnet_publica[*].cidr_block
}

output "subnet_publica_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.subnet_publica[*].id
}

output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.name
}
# API Gateway outputs
output "api_gateway_endpoint" {
  description = "URL do endpoint do API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_apigatewayv2_api.main.id
}

output "api_gateway_stage_name" {
  description = "Nome do stage do API Gateway"
  value       = aws_apigatewayv2_stage.default.name
}

# NLB outputs
output "nlb_dns_name" {
  description = "DNS do Network Load Balancer"
  value       = aws_lb.eks_nlb.dns_name
}

output "nlb_arn" {
  description = "ARN do Network Load Balancer"
  value       = aws_lb.eks_nlb.arn
}

output "vpc_link_id" {
  description = "ID do VPC Link"
  value       = aws_apigatewayv2_vpc_link.eks.id
}
