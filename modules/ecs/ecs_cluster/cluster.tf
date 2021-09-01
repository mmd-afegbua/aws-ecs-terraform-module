resource "aws_ecs_cluster" "admin_tool" {
  name = "${var.cluster_name}-${var.environment}-cluster"
  tags = {
      Name = var.cluster_tag_name
      Env = var.environment
  }
}