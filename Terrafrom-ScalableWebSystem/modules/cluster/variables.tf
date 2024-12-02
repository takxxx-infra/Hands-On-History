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
  type = string
}

variable "instance_type" {
  description = "The instance type to use"
  type = string
  default = "t2.micro"
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type = string
  default = null
}

variable "vpc_id" {
  type = string
}

variable "serve_rport" {
  description = "Server port to use"
  type = number
}

variable "public_subnet_ids" {
  description = "Specifying an Availability Zone"
  type = list(string)
}

variable "desired_capacity" {
  type = number
  default = 2
}

variable "max_size" {
  type = number
  default = 3
}

variable "min_size" {
  type = number
  default = 2
}