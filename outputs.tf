output "vpc_id" {
  description = "ID da VPC criada para a aplicação."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID da subnet pública onde a EC2 será criada."
  value       = module.network.public_subnet_id
}
