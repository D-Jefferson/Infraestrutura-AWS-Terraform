output "instance_id" {
  description = "ID da instância EC2."
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Endereço IPv4 público da instância EC2."
  value       = aws_instance.web.public_ip
}
