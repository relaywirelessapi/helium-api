variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
  type        = string
  nullable    = false
}

variable "app_name" {
  description = "Application name"
  default     = "relay-helium-api"
  type        = string
  nullable    = false
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
  type        = string
  default     = "production"
  nullable    = false
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
  nullable    = false
}

variable "domain_name" {
  description = "The main domain name for the application"
  type        = string
  default     = "api.relaywireless.com"
  nullable    = false
}

variable "email_domain" {
  description = "The domain name to send emails from"
  type        = string
  default     = "relaywireless.com"
  nullable    = false
}

variable "from_address" {
  description = "The email address to send emails from"
  type        = string
  default     = "noreply@relaywireless.com"
  nullable    = false
}

variable "helium_oracles_aws_region" {
  description = "AWS region"
  default     = "us-west-2"
  type        = string
  nullable    = false
}

variable "sidekiq_username" {
  description = "Sidekiq username"
  type        = string
  default     = "admin"
  nullable    = false
}

variable "sentry_dsn" {
  description = "Sentry DSN for error tracking"
  type        = string
  nullable    = false
}

variable "posthog_api_key" {
  description = "PostHog API key for analytics"
  type        = string
  nullable    = false
}

variable "posthog_host" {
  description = "PostHog host URL"
  type        = string
  default     = "https://us.i.posthog.com"
  nullable    = false
}

variable "sidekiq_pro_credentials" {
  description = "Sidekiq Pro credentials"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "solana_rpc_url" {
  description = "Solana RPC URL (with API key)"
  type        = string
  nullable    = false
  sensitive   = true
}
