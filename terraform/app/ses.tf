resource "aws_ses_domain_identity" "main" {
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_iam_user" "ses" {
  name = "${var.app_name}-ses"
}

resource "aws_iam_access_key" "ses" {
  user = aws_iam_user.ses.name
}

resource "aws_iam_user_policy" "ses" {
  name = "ses-policy"
  user = aws_iam_user.ses.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendRawEmail",
          "ses:SendEmail"
        ]
        Resource = "*"
      }
    ]
  })
}

# Add these DNS records to verify your domain:
# 1. TXT record: _amazonses.<domain> with value: <verification_token>
# 2. CNAME records: <dkim_token>._domainkey.<domain> with value: <dkim_token>.dkim.amazonses.<region>.amazonaws.com
# for each of the 3 DKIM tokens

output "ses_verification_token" {
  description = "The verification token for the domain identity"
  value       = aws_ses_domain_identity.main.verification_token
}

output "ses_dkim_tokens" {
  description = "The DKIM tokens for the domain"
  value       = aws_ses_domain_dkim.main.dkim_tokens
}
