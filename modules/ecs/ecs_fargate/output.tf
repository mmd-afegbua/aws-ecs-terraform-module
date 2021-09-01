output alb_arn {
  value       = aws_lb.alb.arn
  description = "ARN for the internal NLB"
}

output alb_dns_address {
  value       = aws_lb.alb.dns_name
  description = "DNS name for the internal NLB"
}

output "target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}