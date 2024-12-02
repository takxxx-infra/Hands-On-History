variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_cidr_block" {
  description = "Public Subnet CIDR Block"
  type        = list(string)
  default     = []
}

variable "private_cidr_block" {
  description = "Private Subnet CIDR Block"
  type        = list(string)
  default     = []
}

variable "availability_zone" {
  type    = list(string)
  default = []
}