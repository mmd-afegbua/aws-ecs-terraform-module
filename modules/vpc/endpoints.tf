# ECR
resource "aws_vpc_endpoint" "ecr_dkr" {
  provider = aws.current

  vpc_id       = aws_vpc.centricity_vpc.id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id

  security_group_ids = [
    aws_security_group.ecs_tasks.id
  ]

  tags = {
    Name = "ECR Docker VPC Endpoint Interface - ${var.environment}"
    Environment = var.environment
  }
}

# CloudWatch
resource "aws_vpc_endpoint" "cloudwatch" {
  provider = aws.current
  vpc_id       = aws_vpc.centricity_vpc.id
  service_name = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids          = aws_subnet.private_subnet.*.id
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.ecs_tasks.id
  ]

  tags = {
    Name = "CloudWatch VPC Endpoint Interface - ${var.environment}"
    Environment = var.environment
  }
}

# S3
resource "aws_vpc_endpoint" "s3" {
  provider = aws.current
  vpc_id       = aws_vpc.centricity_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private_route[0].id]

  tags = {
    Name = "S3 VPC Endpoint Gateway - ${var.environment}"
    Environment = var.environment
  }
}