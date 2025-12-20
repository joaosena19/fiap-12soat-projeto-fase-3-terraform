# Identificação

Aluno: João Pedro Sena Dainese  
Registro FIAP: RM365182  

Turma 12SOAT - Software Architecture  
Grupo individual  
Grupo 15  

Discord: joaodainese  
Email: joaosenadainese@gmail.com  

## Sobre este Repositório

Este repositório contém apenas parte do projeto completo da Fase 3. Para visualizar a documentação completa, diagramas de arquitetura, e todos os componentes do projeto, acesse: [Documentação Completa - Fase 3](https://github.com/joaosena19/fiap-12soat-projeto-fase-3-documentacao)

## Descrição

Infraestrutura base da AWS usando Terraform: VPC, subnets, cluster EKS, Network Load Balancer e integração com New Relic para monitoramento. Fornece a base de rede e compute para os demais componentes do projeto.

## Tecnologias Utilizadas

- **Terraform** - Infraestrutura como código
- **AWS EKS** - Kubernetes gerenciado
- **AWS VPC** - Rede isolada
- **Network Load Balancer** - Balanceador de carga
- **New Relic** - Monitoramento
- **AWS S3** - Backend do Terraform

## Passos para Execução

### 1. Configurar Variáveis

Criar `terraform.tfvars`:
```hcl
bucket_name = "coloque-seu-bucket-aqui"
eks_iam_user_name = "seu-usuario-admin-eks"
eks_cluster_name = "eks-cluster-fiap-12soat-fase3"
new_relic_license_key = "sua-chave-new-relic-aqui"
```

### 2. Deploy

```bash
cd infra
terraform init
terraform plan
terraform apply
```

### 3. Configurar kubectl

```bash
aws eks update-kubeconfig --name eks-cluster-fiap-12soat-fase3 --region us-east-1
kubectl get nodes
```