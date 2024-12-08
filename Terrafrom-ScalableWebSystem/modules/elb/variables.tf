variable "bucket_name" {
  description = "The name of the remote state S3 bucket"
  type        = string
}

variable "network_backet_key" {
  description = "The key for storing network-related remote state in the S3 bucket"
  type        = string
}

variable "security_backet_key" {
  description = "The key for storing security-related remote state in the S3 bucket"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-northeast-1"
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table used for state locking"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The name of the environment (e.g., dev, staging, production)"
  type        = string
}

variable "http_port" {
  description = "The port on which the server will listen for HTTP traffic"
  type        = number
  default     = 80
}

variable "http_protocol" {
  description = "The HTTP protocol to use (e.g., HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}