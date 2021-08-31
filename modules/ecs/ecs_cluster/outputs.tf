output "cluster_arn" {
  description = "Amazon Resource Name for Cluster"
  value = aws_ecs_cluster.admin_tool.arn
}

output "cluster_id" {
  description = "ID for Cluster"
  value = aws_ecs_cluster.admin_tool.id
}