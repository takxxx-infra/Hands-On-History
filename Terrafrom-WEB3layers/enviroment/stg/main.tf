terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = "global/s3/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tfstate-taka-202411-locks"
    encrypt        = true
  }
}

