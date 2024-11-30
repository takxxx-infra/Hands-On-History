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
resource "aws_subnet" "public-subnet" {
  count             = length(var.public_cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-public-${var.availability_zones[count.index]}"
  }
}

# プライベートサブネット
resource "aws_subnet" "private" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-${var.environment}-private-${var.availability_zones[count.index]}"
  }
}

# #################################################
# IGW
# #################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

# #################################################
# Route Table
# #################################################