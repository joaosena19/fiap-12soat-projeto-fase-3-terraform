# Obrigatórias
variable "bucket_name" {
  description = "O nome único para o bucket S3. Deve ser globalmente único."
  type        = string
}

variable "eks_iam_user_name" {
  description = "Nome do usuário IAM que controlará o EKS e será associado às políticas de acesso do cluster."
  type        = string
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS. Exemplo: fiap-12soat-fase2-joaodainese"
  type        = string
}

# Opcionais
variable "aws_region" {
  description = "A região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "O ambiente ao qual o recurso pertence (ex: Dev, Staging, Prod)."
  type        = string
  default     = "Dev"
}

variable "project_name" {
  description = "Nome do projeto para ser usado em tags."
  type        = string
  default     = "FIAP 12SOAT Fase 2 - João Dainese"
}

variable "project_identifier" {
  description = "Identificador único do projeto para ser usado em tags."
  type        = string
  default     = "fiap-12soat-fase2-joaodainese"
}

variable "cidr_vpc" {
  description = "O bloco CIDR para a VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidade na região escolhida onde as subnets serão criadas (deve combinar com aws_region)."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "eks_node_instance_types" {
  description = "Lista de tipos de instância para os nós do EKS."
  type        = list(string)
  default     = ["t3.small"]
}

variable "eks_node_disk_size" {
  description = "Tamanho do disco em GB a ser anexado a cada nó do EKS."
  type        = number
  default     = 20
}

variable "eks_node_scaling_desired_size" {
  description = "Número desejado de nós no grupo do EKS."
  type        = number
  default     = 2
}

variable "eks_node_scaling_max_size" {
  description = "Número máximo de nós no grupo do EKS."
  type        = number
  default     = 3
}

variable "eks_node_scaling_min_size" {
  description = "Número mínimo de nós no grupo do EKS."
  type        = number
  default     = 1
}