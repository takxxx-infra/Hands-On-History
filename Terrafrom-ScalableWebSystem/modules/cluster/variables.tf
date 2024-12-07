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

variable "ami" {
  description = "ID of the ami to use"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t2.micro"
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 2
}

variable "target_group_arns" {
  type = string
}