# Path: infrastructure/terraform/aws/variables.tf

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "aws_region_fallback" {
  type    = string
  default = "ap-south-2"
}

variable "environment" {
  type = string
}

variable "app_name" {
  type    = string
  default = "devops-assignment"
}

variable "container_cpu" {
  type    = number
  default = 256
}

variable "container_memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type = number
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}
