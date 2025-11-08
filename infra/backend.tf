terraform {
  backend "s3" {
    bucket = "fiap-12soat-fase2-joao-dainese"
    key    = "infra/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

