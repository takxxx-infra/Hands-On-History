# #################################################
# Backend
# #################################################
terraform {
  required_version = "~>1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3" {
    bucket         = "tfstate-20241130"
    key            = "dev/data-stores/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tfstate-20241130-locks"
    encrypt        = true
  }
}
# #################################################
# Provider
# #################################################
provider "aws" {
  region = "ap-northeast-1"
}

# #################################################
# RDS
# #################################################
module "rds" {
  source              = "../../../modules/rds"
  bucket_name         = "tfstate-20241130"
  network_backet_key  = "dev/networks/terraform.tfstate"
  security_backet_key = "dev/security/terraform.tfstate"
  dynamodb_table      = "tfstate-20241130-locks"
  project             = "scalablewebsystem"
  environment         = "dev"
  db_name             = "wordpress"
  db_username         = var.db_username
  db_password         = var.db_password
}
