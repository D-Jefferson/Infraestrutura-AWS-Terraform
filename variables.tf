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

variable "instance_type" {
  description = "Tipo da instância EC2 usada pela aplicação."
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Nome do projeto usado nas tags dos recursos."
  type        = string
  default     = "terraform-aws-nginx"
}

variable "vpc_cidr" {
  description = "Bloco IPv4 da VPC. A primeira subnet /24 será usada pela aplicação."
  type        = string
  default     = "10.42.0.0/16"
}
