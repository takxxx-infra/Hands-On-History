variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The name of the environment (e.g., dev, staging, production)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_cidr_block" {
  description = "The list of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "private_cidr_block" {
  description = "The list of CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "availability_zone" {
  description = "The list of availability zones to use"
  type        = list(string)
  default     = []
}