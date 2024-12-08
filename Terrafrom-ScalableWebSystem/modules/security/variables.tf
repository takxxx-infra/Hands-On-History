variable "bucket_name" {
  description = "The name of the S3 bucket for storing remote state"
  type        = string
}

variable "bucket_key" {
  description = "The key for storing remote state in the S3 bucket"
  type        = string
}

variable "region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "ap-northeast-1"
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table used for remote state locking"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment for the project (e.g., dev, staging, production)"
  type        = string
}

variable "server_port" {
  description = "The port number on which the server will listen"
  type        = number
}

variable "http_port" {
  description = "The HTTP port for the server (default: 80)"
  type        = number
  default     = 80
}

variable "db_port" {
  description = "The port number for the MySQL database (default: 3306)"
  type        = number
  default     = 3306
}