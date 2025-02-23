# Policy for deployment operations
data "aws_iam_policy_document" "deployment_policy" {
  statement {
    effect = "Allow"
    actions = [
      # IAM permissions for task execution
      "iam:PassRole",
      "iam:GetRole",
      "iam:GetUser",
      "iam:ListRolePolicies",
      "iam:GetUserPolicy",
      "iam:ListAccessKeys",
      "iam:GetRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",

      # DynamoDB permissions for Terraform state locking
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",

      # SSM Parameter Store permissions
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:DeleteParameters",
      "ssm:DescribeParameters",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:LabelParameterVersion",

      # Infrastructure management
      "ecr:*",
      "ecs:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "rds:*",
      "elasticache:*",
      "ses:*",
      "acm:*",
      "route53:*",
      "logs:*",
      "cloudwatch:*",
      "secretsmanager:*",
      "ssm:*",
      "s3:*",
      "kms:*",
      "elasticfilesystem:*",
      "application-autoscaling:*",
      "autoscaling:*"
    ]
    resources = ["*"]
  }
}

# Create the IAM policy
resource "aws_iam_policy" "deployment_policy" {
  name        = "${var.app_name}-deployment-policy"
  description = "Policy for Helium API deployment operations"
  policy      = data.aws_iam_policy_document.deployment_policy.json

  tags = {
    Name        = "${var.app_name}-deployment-policy"
    Environment = "meta"
  }
}

# Create IAM user for deployments
resource "aws_iam_user" "deployment_user" {
  name = "${var.app_name}-deployer"

  tags = {
    Name        = "${var.app_name}-deployer"
    Environment = "meta"
  }
}

# Create access key for deployment user
resource "aws_iam_access_key" "deployment_user" {
  user = aws_iam_user.deployment_user.name
}

# Attach the deployment policy to the user
resource "aws_iam_user_policy_attachment" "deployment_user_policy" {
  user       = aws_iam_user.deployment_user.name
  policy_arn = aws_iam_policy.deployment_policy.arn
}

# Output the deployment user's access key ID and secret
output "deployer_access_key_id" {
  value = aws_iam_access_key.deployment_user.id
}

output "deployer_secret_access_key" {
  value     = aws_iam_access_key.deployment_user.secret
  sensitive = true
}
