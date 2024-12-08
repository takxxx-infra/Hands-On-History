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
    key            = "dev/security/terraform.tfstate"
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
# Security
# #################################################
module "security" {
  source         = "../../../modules/security"
  bucket_name    = "tfstate-20241130"
  bucket_key     = "dev/networks/terraform.tfstate"
  dynamodb_table = "tfstate-20241130-locks"
  project        = "ScalableWebSystem"
  environment    = "dev"
  server_port    = 80
}