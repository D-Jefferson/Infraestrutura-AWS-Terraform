output "state_bucket_name" {
  description = "Nome do bucket a informar na inicialização do backend principal."
  value       = aws_s3_bucket.state.bucket
}

output "aws_region" {
  description = "Região do bucket a informar na inicialização do backend principal."
  value       = var.aws_region
}
