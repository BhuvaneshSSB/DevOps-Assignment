# Path: infrastructure/terraform/aws-prod/variables.tf

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "aws_region_fallback" {
  type    = string
  default = "ap-south-2"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "app_name" {
  type    = string
  default = "devops-assignment"
}

variable "container_cpu" {
  type    = number
  default = 512
}

variable "container_memory" {
  type    = number
  default = 1024
}

variable "desired_count" {
  type    = number
  default = 3
}

variable "min_capacity" {
  type    = number
  default = 3
}

variable "max_capacity" {
  type    = number
  default = 10
}
