# Path: infrastructure/terraform/aws-dev/variables.tf

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
  default = "dev"
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
  type    = number
  default = 1
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "max_capacity" {
  type    = number
  default = 2
}

variable "github_repository" {
  type        = string
  description = "GitHub repository in format owner/repo"
  default     = "BhuvaneshSSB/DevOps-Assignment"
}
