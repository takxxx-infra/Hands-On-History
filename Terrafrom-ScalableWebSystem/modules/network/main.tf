# #################################################
# VPC
# #################################################
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Project     = var.project
    Environment = var.environment
  }
}

# #################################################
# Subnet
# #################################################
# パブリックサブネット
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr_block

  tags = {
    Name = "${var.project}-${var.environment}-public-subnet"
  }
}

# プライベートサブネット
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr_block

  tags = {
    Name = "${var.project}-${var.environment}-private-subnet"
  }
}