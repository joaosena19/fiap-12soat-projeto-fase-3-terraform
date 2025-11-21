# Security Group para o NLB
resource "aws_security_group" "nlb_sg" {
  name        = "${var.project_identifier}-nlb-sg"
  description = "Security group para Network Load Balancer"
  vpc_id      = aws_vpc.vpc_principal.id

  ingress {
    description = "HTTP de qualquer lugar"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS de qualquer lugar"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Permitir todo trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_identifier}-nlb-sg"
  }
}

# Network Load Balancer para o EKS
resource "aws_lb" "eks_nlb" {
  name               = "${var.project_identifier}-eks-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.subnet_publica[*].id

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_identifier}-eks-nlb"
  }
}

# Target Group para o NLB (HTTP na porta 80)
resource "aws_lb_target_group" "eks_tg" {
  name        = "${var.project_identifier}-eks-tg"
  port        = 30080
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc_principal.id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
    protocol            = "TCP"
    port                = "30080"
  }

  tags = {
    Name = "${var.project_identifier}-eks-tg"
  }
}

# Listener do NLB na porta 80
resource "aws_lb_listener" "eks_listener" {
  load_balancer_arn = aws_lb.eks_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_tg.arn
  }
}

data "aws_instances" "eks_nodes" {
  instance_tags = {
    "eks:cluster-name" = var.eks_cluster_name
  }
  instance_state_names = ["running"]
}

locals {
  eks_nodes = data.aws_instances.eks_nodes.ids
}

resource "aws_lb_target_group_attachment" "eks_nodes" {
  for_each         = toset(local.eks_nodes != null ? local.eks_nodes : [])
  target_group_arn = aws_lb_target_group.eks_tg.arn
  target_id        = each.value
  port             = 30080
}

# Regra para permitir que o NLB acesse os nós do EKS na porta do NodePort
resource "aws_security_group_rule" "allow_nlb_to_eks_nodes" {
  type        = "ingress"
  description = "Permitir trafego do NLB para os nos do EKS na porta 30080"
  from_port   = 30080
  to_port     = 30080
  protocol    = "tcp"

  # A origem é o Security Group do NLB
  source_security_group_id = aws_security_group.nlb_sg.id

  # O destino é o Security Group automático do Cluster EKS (onde os nós estão)
  security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id

  depends_on = [aws_eks_cluster.eks_cluster]
}