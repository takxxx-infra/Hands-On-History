variable "bucket_name" {
  description = "The name of the remote state S3 bucket"
  type        = string
}

variable "network_bucket_key" {
  description = "The key used for the network state in the remote S3 bucket"
  type        = string
}

variable "security_bucket_key" {
  description = "The key used for the security state in the remote S3 bucket"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-northeast-1"
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table for state locking"
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

variable "ami" {
  description = "The ID of the AMI to use for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to use"
  type        = string
  default     = "t2.micro"
}

variable "user_data" {
  description = "The User Data script to run when the instance boots"
  type        = string
  default     = null
}

variable "desired_capacity" {
  description = "The desired number of instances in the Auto Scaling group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of instances in the Auto Scaling group"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of instances in the Auto Scaling group"
  type        = number
  default     = 2
}

variable "target_group_arns" {
  description = "The ARNs of the target groups to associate with the Auto Scaling group"
  type        = string
}