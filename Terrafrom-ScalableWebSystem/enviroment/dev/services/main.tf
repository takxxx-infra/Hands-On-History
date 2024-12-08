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
  user_data           = filebase64("./initialize.sh")
  target_group_arns   = module.alb.target_group_arn
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
