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
    key            = "dev/networks/terraform.tfstate"
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
# NetWorks
# #################################################
module "network" {
  source = "../../../modules/network"

  project            = "ScalableWebSystem"
  environment        = "dev"
  vpc_cidr_block     = "10.0.0.0/16"
  public_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zone  = ["ap-northeast-1a", "ap-northeast-1c"]
}
