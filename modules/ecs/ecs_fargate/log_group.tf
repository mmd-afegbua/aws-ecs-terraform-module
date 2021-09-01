resource "aws_cloudwatch_log_group" "main" {
  name = var.ecs_cloudwatchlog_group

  tags = {
    Environment = var.environment
    }
}