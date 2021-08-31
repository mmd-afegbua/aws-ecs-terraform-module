resource "aws_cloudwatch_log_group" "main" {
    provider = aws.current
  name = var.ecs_cloudwatchlog_group

  tags = {
    Environment = var.environment
    }
}