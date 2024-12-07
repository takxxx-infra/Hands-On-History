variable "bucket_name" {
  description = "The name of remote state bucket name"
  type        = string
}

variable "network_backet_key" {
  description = "The name of remote state bucket key"
  type        = string
}

variable "security_backet_key" {
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

variable "db_name" {
  description = "The name of the rds database name"
  type        = string
  default     = null
}

variable "db_engine" {
  description = "The engine of the rds database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_size" {
  type    = number
  default = 10
}

variable "db_instance_type" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type      = string
  sensitive = true
  default   = null
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = null
}

variable "replication_source_db" {
  type    = string
  default = null
}