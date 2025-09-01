resource "aws_iam_role" "ecs_execution" {
  name = "${var.app_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_execution_ssm" {
  name = "${var.app_name}-ecs-execution-ssm-policy"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]
        Resource = [
          aws_ssm_parameter.db_password.arn,
          aws_ssm_parameter.secret_key_base.arn,
          aws_ssm_parameter.devise_pepper.arn,
          aws_ssm_parameter.domain_name.arn,
          aws_ssm_parameter.from_address.arn,
          aws_ssm_parameter.helium_oracles_aws_access_key_id.arn,
          aws_ssm_parameter.helium_oracles_aws_secret_access_key.arn,
          aws_ssm_parameter.helium_oracles_aws_region.arn,
          aws_ssm_parameter.sentry_dsn.arn,
          aws_ssm_parameter.posthog_api_key.arn,
          aws_ssm_parameter.posthog_host.arn,
          aws_ssm_parameter.webhook_auth_keys.arn,
          aws_ssm_parameter.solana_rpc_url.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_execution_ecr" {
  name = "${var.app_name}-ecs-execution-ecr-policy"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.app_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task_exec" {
  name = "${var.app_name}-ecs-task-exec-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM user for Helium Oracles S3 access
resource "aws_iam_user" "helium_oracles" {
  name = "${var.app_name}-helium-oracles-user"

  tags = {
    Name        = "${var.app_name}-helium-oracles-user"
    Environment = var.environment
  }
}

# Access key for the Helium Oracle IAM user
resource "aws_iam_access_key" "helium_oracles" {
  user = aws_iam_user.helium_oracles.name
}

# IAM policy for Helium Oracle S3 access
resource "aws_iam_policy" "helium_oracles_s3" {
  name        = "${var.app_name}-helium-oracles-s3-policy"
  description = "Policy for accessing Helium Oracles S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
        ]
        Resource = [
          "arn:aws:s3:::foundation-poc-data-requester-pays",
          "arn:aws:s3:::foundation-poc-data-requester-pays/*",
          "arn:aws:s3:::foundation-helium-l1-archive-requester-pays",
          "arn:aws:s3:::foundation-helium-l1-archive-requester-pays/*"
        ]
      }
    ]
  })
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "helium_oracles_s3" {
  user       = aws_iam_user.helium_oracles.name
  policy_arn = aws_iam_policy.helium_oracles_s3.arn
}
