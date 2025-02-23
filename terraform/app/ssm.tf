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
  value       = "relay-helium-api.alessandro.codes"
}

resource "aws_ssm_parameter" "from_address" {
  name        = "/${var.app_name}/${var.environment}/from_address"
  description = "The email address to send emails from"
  type        = "String"
  value       = "noreply@relay-helium-api.alessandro.codes"
}

# Generate random passwords for the parameters
resource "random_password" "db_password" {
  length  = 32
  special = true
}

resource "random_password" "secret_key_base" {
  length  = 64
  special = true
}

resource "random_password" "devise_pepper" {
  length  = 32
  special = true
}
