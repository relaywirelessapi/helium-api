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
  default     = "helium-api.relaywireless.com"
}

variable "email_domain" {
  description = "The domain name to send emails from"
  type        = string
  default     = "relaywireless.com"
}

variable "from_address" {
  description = "The email address to send emails from"
  type        = string
  default     = "noreply@relaywireless.com"
}

variable "helium_oracles_aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "helium_oracles_aws_access_key_id" {
  description = "AWS access key id"
  default     = "us-east-1"
}
