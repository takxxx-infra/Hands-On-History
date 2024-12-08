variable "bucket_name" {
  description = "The name of the remote state S3 bucket"
  type        = string
}

variable "network_bucket_key" {
  description = "The key for storing network-related remote state in the S3 bucket"
  type        = string
}

variable "security_bucket_key" {
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

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
  default     = null
}

variable "db_engine" {
  description = "The database engine to use for RDS (e.g., MySQL, PostgreSQL)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The version of the RDS database engine"
  type        = string
  default     = "8.0"
}

variable "db_size" {
  description = "The allocated storage size (in GB) for the RDS database"
  type        = number
  default     = 10
}

variable "db_instance_type" {
  description = "The instance type for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "The username for the RDS database (sensitive)"
  type        = string
  sensitive   = true
  default     = null
}

variable "db_password" {
  description = "The password for the RDS database (sensitive)"
  type        = string
  sensitive   = true
  default     = null
}

variable "replication_source_db" {
  description = "The ARN of the source database for replication, if applicable"
  type        = string
  default     = null
}