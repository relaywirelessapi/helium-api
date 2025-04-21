variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "app_name" {
  description = "Application name"
  default     = "relay-helium-api"
}

output "app_name" {
  description = "Application name"
  value       = var.app_name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
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
  default     = "us-west-2"
}

variable "sidekiq_username" {
  description = "Sidekiq username"
  type        = string
  default     = "admin"
}

variable "sentry_dsn" {
  description = "Sentry DSN for error tracking"
  type        = string
}

variable "posthog_api_key" {
  description = "PostHog API key for analytics"
  type        = string
}

variable "posthog_host" {
  description = "PostHog host URL"
  type        = string
  default     = "https://us.i.posthog.com"
}
