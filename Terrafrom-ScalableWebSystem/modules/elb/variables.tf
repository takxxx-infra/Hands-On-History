variable "bucket_name" {
  description = "The name of remote state bucket name"
  type        = string
}

variable "backet_key" {
  description = "The name of remote state bucket key"
  type        = string
}

variable "region" {
  description = "Use region"
  type        = string
  default     = "ap-northeast-1"
}

variable "dynamodb_table" {
  description = "The name of remote state bucket lock"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "http_port" {
  description = "Server port to use"
  type        = number
  default     = 80
}

variable "http_protocol" {
  description = "The protcol of http protocol"
  type        = string
  default     = "HTTP"
}