variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name"
  default     = "relay-helium-api"
}

output "app_name" {
  description = "Application name"
  value       = var.app_name
}

variable "environment" {
  description = "Environment (staging/production)"
  default     = "production"
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

variable "domain_name" {
  description = "The main domain name for the application"
  type        = string
  default     = "relay-helium-api.alessandro.codes"
}

variable "from_address" {
  description = "The email address to send emails from"
  type        = string
  default     = "noreply@relay-helium-api.alessandro.codes"
}
