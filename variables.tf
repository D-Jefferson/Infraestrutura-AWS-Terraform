variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Nome do ambiente usado nas tags dos recursos."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nome do projeto usado nas tags dos recursos."
  type        = string
  default     = "terraform-aws-nginx"
}
