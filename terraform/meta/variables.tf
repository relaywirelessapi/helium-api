variable "app_name" {
  description = "Application name"
  default     = "relay-helium-api"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

output "aws_region" {
  value       = var.aws_region
  description = "The AWS region"
}
