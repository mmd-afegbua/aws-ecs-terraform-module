output vpc_arn {
  value = aws_vpc.main.arn
}

output vpc_id {
  value = aws_vpc.main.id
}

output private_subnet_ids {
  value = aws_subnet.private_subnet.*.id
}

output public_subnet_ids {
  value = aws_subnet.public_subnet.*.id
}

output ecs_tasks_security_group_id {
  value = aws_security_group.ecs_tasks.id
}

output alb_security_group_id {
  value = aws_security_group.lb.*.id
}

output "private_route" {
  value = aws_route_table.private_route[0].id
}