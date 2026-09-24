output "vpc_id" {
  description = "ID da VPC criada para a aplicação."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID da subnet pública onde a EC2 será criada."
  value       = module.network.public_subnet_id
}

output "instance_id" {
  description = "ID da instância EC2."
  value       = module.web.instance_id
}

output "instance_public_ip" {
  description = "Endereço IPv4 público da instância EC2."
  value       = module.web.public_ip
}

output "app_url" {
  description = "Endereço HTTP da aplicação."
  value       = "http://${module.web.public_ip}"
}
