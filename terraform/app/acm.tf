data "aws_ssm_parameter" "domain_name" {
  name = "/${var.app_name}/${var.environment}/domain_name"
}

resource "aws_acm_certificate" "main" {
  domain_name       = data.aws_ssm_parameter.domain_name.value
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.app_name}-certificate"
    Environment = var.environment
  }
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_acm_certificate.main.domain_validation_options : record.resource_record_name]
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.main.arn
}

output "acm_validation_records" {
  description = "The DNS records needed for ACM certificate validation"
  value = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}
