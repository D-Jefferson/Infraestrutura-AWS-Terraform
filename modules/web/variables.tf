variable "name_prefix" {
  description = "Prefixo dos nomes dos recursos da aplicação."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
}

variable "public_subnet_id" {
  description = "ID da subnet pública onde a EC2 será criada."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
}
