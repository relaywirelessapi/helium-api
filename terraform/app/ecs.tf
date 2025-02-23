resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.app_name}-cluster"
    Environment = var.environment
  }
}

locals {
  container_environment = [
    {
      name  = "RAILS_ENV"
      value = var.environment
    },
    {
      name  = "DATABASE_URL"
      value = "postgres://postgres:${aws_ssm_parameter.db_password.value}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.db_name}"
    },
    {
      name  = "REDIS_URL"
      value = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}/0"
    },
    {
      name  = "SECRET_KEY_BASE"
      value = aws_ssm_parameter.secret_key_base.value
    },
    {
      name  = "DEVISE_PEPPER"
      value = aws_ssm_parameter.devise_pepper.value
    },
    {
      name  = "DOMAIN_NAME"
      value = aws_ssm_parameter.domain_name.value
    },
    {
      name  = "SMTP_USERNAME"
      value = aws_iam_access_key.ses.id
    },
    {
      name  = "SMTP_PASSWORD"
      value = aws_iam_access_key.ses.ses_smtp_password_v4
    },
    {
      name  = "SMTP_ADDRESS"
      value = "email-smtp.${var.aws_region}.amazonaws.com"
    },
    {
      name  = "SMTP_PORT"
      value = "587"
    },
    {
      name  = "FROM_ADDRESS"
      value = aws_ssm_parameter.from_address.value
    }
  ]
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.app_name}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "${var.app_name}-web"
      image = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"

      environment = local.container_environment

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/up || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "${var.app_name}-sidekiq"
        }
      }

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.app_name}-web-task-definition"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "sidekiq" {
  family                   = "${var.app_name}-sidekiq"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name    = "${var.app_name}-sidekiq"
      image   = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
      command = ["bundle", "exec", "sidekiq"]

      environment = local.container_environment

      healthCheck = {
        command     = ["CMD-SHELL", "ps aux | grep '[s]idekiq' || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "${var.app_name}-sidekiq"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.app_name}-sidekiq-task-definition"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "web" {
  name                   = "${var.app_name}-web"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.web.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  force_new_deployment   = true
  enable_execute_command = true

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  enable_ecs_managed_tags            = true
  health_check_grace_period_seconds  = 60

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "${var.app_name}-web"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.app_http, aws_lb_listener.app_https, aws_route_table_association.private]

  tags = {
    Name        = "${var.app_name}-web-service"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "sidekiq" {
  name                   = "${var.app_name}-sidekiq"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.sidekiq.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  force_new_deployment   = true
  enable_execute_command = true

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false
  }

  depends_on = [aws_route_table_association.private]

  tags = {
    Name        = "${var.app_name}-sidekiq-service"
    Environment = var.environment
  }
}
