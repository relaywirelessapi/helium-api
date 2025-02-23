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

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}
