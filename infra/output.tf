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