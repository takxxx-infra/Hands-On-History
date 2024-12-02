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
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "tfstate-20241130"
    key            = "dev/networks/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tfstate-20241130-locks"
  }
}


# #################################################
# Services
# #################################################

module "cluster" {
  source            = "../../../modules/cluster"
  project           = "ScalableWebSystem"
  environment       = "dev"
  ami               = "ami-023ff3d4ab11b2525"
  user_data         = filebase64("./initialize.sh")
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
  serve_rport       = 80
}
