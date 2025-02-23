variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name"
  default     = "relay-helium-api"
}

variable "environment" {
  description = "Environment (staging/production)"
  default     = "production"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "db_password" {
  description = "RDS master password"
  sensitive   = true
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

variable "secret_key_base" {
  description = "Secret key base"
  type        = string
  sensitive   = true
}

variable "devise_pepper" {
  description = "Devise pepper"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The main domain name for the application (e.g., example.com)"
  type        = string
}

variable "from_address" {
  description = "The email address to send emails from"
  type        = string
}
