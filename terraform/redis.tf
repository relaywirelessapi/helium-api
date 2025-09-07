resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.app_name}-redis-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.app_name}-redis"
  description          = "Redis cluster for ${var.app_name}"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = "cache.m5.large"
  num_cache_clusters   = 1
  parameter_group_name = "default.redis7"
  port                 = 6379

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.redis.id]

  # Enable encryption at rest
  at_rest_encryption_enabled = true

  # Maintenance window
  maintenance_window = "sun:02:00-sun:03:00" # UTC time
  apply_immediately  = true

  # Enable automatic minor version upgrades
  auto_minor_version_upgrade = true

  # Preferred availability zone
  preferred_cache_cluster_azs = [data.aws_availability_zones.available.names[0]]

  tags = {
    Name        = "${var.app_name}-redis"
    Environment = var.environment
  }
}

output "redis_endpoint" {
  value = "${aws_elasticache_replication_group.redis.primary_endpoint_address}:${aws_elasticache_replication_group.redis.port}"
}
