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
      value = "redis://${aws_elasticache_replication_group.redis.primary_endpoint_address}:${aws_elasticache_replication_group.redis.port}/0"
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
    },
    {
      name  = "HELIUM_ORACLES_AWS_REGION"
      value = aws_ssm_parameter.helium_oracles_aws_region.value
    },
    {
      name  = "HELIUM_ORACLES_AWS_ACCESS_KEY_ID"
      value = aws_ssm_parameter.helium_oracles_aws_access_key_id.value
    },
    {
      name  = "HELIUM_ORACLES_AWS_SECRET_ACCESS_KEY"
      value = aws_ssm_parameter.helium_oracles_aws_secret_access_key.value
    },
    {
      name  = "SENTRY_DSN"
      value = aws_ssm_parameter.sentry_dsn.value
    },
    {
      name  = "POSTHOG_API_KEY"
      value = aws_ssm_parameter.posthog_api_key.value
    },
    {
      name  = "POSTHOG_HOST"
      value = aws_ssm_parameter.posthog_host.value
    },
    {
      name  = "SIDEKIQ_USERNAME"
      value = aws_ssm_parameter.sidekiq_username.value
    },
    {
      name  = "SIDEKIQ_PASSWORD"
      value = aws_ssm_parameter.sidekiq_password.value
    }
  ]
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.app_name}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
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
          awslogs-stream-prefix = "${var.app_name}-web"
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

resource "aws_ecs_task_definition" "sidekiq_low" {
  family                   = "${var.app_name}-sidekiq-low"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name    = "${var.app_name}-sidekiq-low"
      image   = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
      command = ["bundle", "exec", "sidekiq", "-q", "low", "-c", "10"]

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
          awslogs-stream-prefix = "${var.app_name}-sidekiq-low"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.app_name}-sidekiq-low-task-definition"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "sidekiq_default" {
  family                   = "${var.app_name}-sidekiq-default"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name    = "${var.app_name}-sidekiq-default"
      image   = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
      command = ["bundle", "exec", "sidekiq", "-q", "default", "-c", "10"]

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
          awslogs-stream-prefix = "${var.app_name}-sidekiq-default"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.app_name}-sidekiq-default-task-definition"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "sidekiq_high" {
  family                   = "${var.app_name}-sidekiq-high"
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
      name    = "${var.app_name}-sidekiq-high"
      image   = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
      command = ["bundle", "exec", "sidekiq", "-q", "high", "-c", "5"]

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
          awslogs-stream-prefix = "${var.app_name}-sidekiq-high"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.app_name}-sidekiq-high-task-definition"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "clockwork" {
  family                   = "${var.app_name}-clockwork"
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
      name    = "${var.app_name}-clockwork"
      image   = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
      command = ["bundle", "exec", "clockwork", "clock.rb"]

      environment = local.container_environment

      healthCheck = {
        command     = ["CMD-SHELL", "ps aux | grep '[c]lockwork' || exit 1"]
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
          awslogs-stream-prefix = "${var.app_name}-clockwork"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.app_name}-clockwork-task-definition"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "web" {
  name                   = "${var.app_name}-web"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.web.arn
  desired_count          = 2
  launch_type            = "FARGATE"
  force_new_deployment   = true
  enable_execute_command = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

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

resource "aws_appautoscaling_target" "web" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.web.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "web_cpu" {
  name               = "${var.app_name}-web-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.web.resource_id
  scalable_dimension = aws_appautoscaling_target.web.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "web_memory" {
  name               = "${var.app_name}-web-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.web.resource_id
  scalable_dimension = aws_appautoscaling_target.web.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

resource "aws_ecs_service" "sidekiq_low" {
  name                   = "${var.app_name}-sidekiq-low"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.sidekiq_low.arn
  desired_count          = 2
  launch_type            = "FARGATE"
  force_new_deployment   = true
  enable_execute_command = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false
  }

  depends_on = [aws_route_table_association.private]

  tags = {
    Name        = "${var.app_name}-sidekiq-low-service"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "sidekiq_default" {
  name                   = "${var.app_name}-sidekiq-default"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.sidekiq_default.arn
  desired_count          = 2
  launch_type            = "FARGATE"
  force_new_deployment   = true
  enable_execute_command = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false
  }

  depends_on = [aws_route_table_association.private]

  tags = {
    Name        = "${var.app_name}-sidekiq-default-service"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "sidekiq_high" {
  name                   = "${var.app_name}-sidekiq-high"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.sidekiq_high.arn
  desired_count          = 2
  launch_type            = "FARGATE"
  force_new_deployment   = true
  enable_execute_command = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false
  }

  depends_on = [aws_route_table_association.private]

  tags = {
    Name        = "${var.app_name}-sidekiq-high-service"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "clockwork" {
  name                   = "${var.app_name}-clockwork"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.clockwork.arn
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
    Name        = "${var.app_name}-clockwork-service"
    Environment = var.environment
  }
}
