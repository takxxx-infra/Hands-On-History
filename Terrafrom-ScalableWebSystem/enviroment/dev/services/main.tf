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
    key            = "dev/services/terraform.tfstate"
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
# Data
# #################################################
# RDSの接続先情報を取得
data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    bucket = "tfstate-20241130"
    key    = "dev/data-stores/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

# #################################################
# Services
# #################################################

module "cluster" {
  source              = "../../../modules/cluster"
  bucket_name         = "tfstate-20241130"
  network_bucket_key  = "dev/networks/terraform.tfstate"
  security_bucket_key = "dev/security/terraform.tfstate"
  dynamodb_table      = "tfstate-20241130-locks"
  project             = "ScalableWebSystem"
  environment         = "dev"
  ami                 = "ami-023ff3d4ab11b2525"
  user_data = base64encode(templatefile("./initialize.sh", {
    server_header = "Terraform Hands on Study!!"
    db_address    = data.terraform_remote_state.rds.outputs.db_address
  }))
  target_group_arns = module.alb.target_group_arn

  depends_on = [module.alb]
}

module "alb" {
  source              = "../../../modules/elb"
  bucket_name         = "tfstate-20241130"
  network_bucket_key  = "dev/networks/terraform.tfstate"
  security_bucket_key = "dev/security/terraform.tfstate"
  dynamodb_table      = "tfstate-20241130-locks"
  project             = "ScalableWebSystem"
  environment         = "dev"
}
