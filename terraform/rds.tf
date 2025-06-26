resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name        = "${var.app_name}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = "${var.app_name}-db"
  engine            = "postgres"
  engine_version    = "17.4"
  instance_class    = "db.t3.large"
  allocated_storage = 50

  db_name  = "rails_production"
  username = "postgres"
  password = aws_ssm_parameter.db_password.value

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  multi_az = true

  max_allocated_storage = 500

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  storage_encrypted = true
  storage_type      = "gp3"

  auto_minor_version_upgrade = true
  maintenance_window         = "Mon:03:00-Mon:04:00"
  backup_retention_period    = 0
  skip_final_snapshot        = true

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  parameter_group_name = aws_db_parameter_group.postgres.name

  tags = {
    Name        = "${var.app_name}-db"
    Environment = var.environment
  }
}

resource "aws_db_parameter_group" "postgres" {
  family = "postgres17"
  name   = "${var.app_name}-pg17-params"

  parameter {
    name  = "log_min_duration_statement"
    value = "1000" # Log queries taking more than 1 second
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  parameter {
    name  = "log_temp_files"
    value = "0"
  }

  tags = {
    Name        = "${var.app_name}-pg17-params"
    Environment = var.environment
  }
}

resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.app_name}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

output "database_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
