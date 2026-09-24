output "vpc_id" {
  description = "ID da VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID da subnet pública."
  value       = aws_subnet.public.id
}
