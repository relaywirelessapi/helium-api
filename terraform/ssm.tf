resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.app_name}/${var.environment}/db_password"
  description = "RDS master password"
  type        = "SecureString"
  value       = random_password.db_password.result
}

resource "aws_ssm_parameter" "secret_key_base" {
  name        = "/${var.app_name}/${var.environment}/secret_key_base"
  description = "Rails secret key base"
  type        = "SecureString"
  value       = random_password.secret_key_base.result
}

resource "aws_ssm_parameter" "devise_pepper" {
  name        = "/${var.app_name}/${var.environment}/devise_pepper"
  description = "Devise pepper"
  type        = "SecureString"
  value       = random_password.devise_pepper.result
}

resource "aws_ssm_parameter" "domain_name" {
  name        = "/${var.app_name}/${var.environment}/domain_name"
  description = "The main domain name for the application"
  type        = "String"
  value       = var.domain_name
}

resource "aws_ssm_parameter" "from_address" {
  name        = "/${var.app_name}/${var.environment}/from_address"
  description = "The email address to send emails from"
  type        = "String"
  value       = var.from_address
}

resource "aws_ssm_parameter" "helium_oracles_aws_access_key_id" {
  name        = "/${var.app_name}/${var.environment}/helium-oracles-aws-access-key-id"
  description = "Helium Oracle AWS Access Key ID"
  type        = "SecureString"
  value       = aws_iam_access_key.helium_oracles.id

  tags = {
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "helium_oracles_aws_secret_access_key" {
  name        = "/${var.app_name}/${var.environment}/helium-oracles-aws-secret-access-key"
  description = "Helium Oracle AWS Secret Access Key"
  type        = "SecureString"
  value       = aws_iam_access_key.helium_oracles.secret

  tags = {
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "helium_oracles_aws_region" {
  name        = "/${var.app_name}/${var.environment}/helium-oracles-aws-region"
  description = "Helium Oracles AWS Region"
  type        = "String"
  value       = var.helium_oracles_aws_region

  tags = {
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "sentry_dsn" {
  name        = "/${var.app_name}/${var.environment}/sentry_dsn"
  description = "Sentry DSN"
  type        = "String"
  value       = var.sentry_dsn
}

resource "aws_ssm_parameter" "posthog_api_key" {
  name        = "/${var.app_name}/${var.environment}/posthog_api_key"
  description = "PostHog API key"
  type        = "String"
  value       = var.posthog_api_key
}

resource "aws_ssm_parameter" "posthog_host" {
  name        = "/${var.app_name}/${var.environment}/posthog_host"
  description = "PostHog host URL"
  type        = "String"
  value       = var.posthog_host
}

resource "aws_ssm_parameter" "sidekiq_username" {
  name        = "/${var.app_name}/${var.environment}/sidekiq_username"
  description = "Sidekiq username"
  type        = "String"
  value       = var.sidekiq_username
}

resource "aws_ssm_parameter" "sidekiq_password" {
  name        = "/${var.app_name}/${var.environment}/sidekiq_password"
  description = "Sidekiq password"
  type        = "SecureString"
  value       = random_password.sidekiq_password.result
}

resource "aws_ssm_parameter" "sidekiq_pro_credentials" {
  name        = "/${var.app_name}/${var.environment}/sidekiq_pro_credentials"
  description = "Sidekiq Pro credentials"
  type        = "SecureString"
  value       = var.sidekiq_pro_credentials
}

# Generate random passwords for the parameters
resource "random_password" "db_password" {
  length  = 32
  special = false
}

resource "random_password" "secret_key_base" {
  length  = 64
  special = false
}

resource "random_password" "devise_pepper" {
  length  = 32
  special = false
}

resource "random_password" "sidekiq_password" {
  length  = 32
  special = false
}
