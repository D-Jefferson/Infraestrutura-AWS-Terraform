variable "aws_region" {
  description = "Região onde o bucket de state será criado."
  type        = string
  default     = "us-east-2"
}

variable "state_bucket_name" {
  description = "Nome globalmente único do bucket S3 usado pelo backend remoto."
  type        = string
}
