resource "aws_lb" "alb" {
    provider = aws.current
    name = "alb-${var.cluster_name}" 
    internal = var.internal_loadbalancer
    load_balancer_type = "application"
    subnets = var.public_subnet_ids
    security_groups = var.alb_sg_group
    enable_deletion_protection = var.enable_lb_deletion

    tags = {
        Name = var.cluster_name
        Env = var.environment
    }
}

resource "aws_lb_target_group" "alb_tg" {
    provider = aws.current
    name = "ecs-fargate-${var.environment}-tg"
    port = var.container_port
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "ip"  
    health_check {    
      interval            = var.interval
      path                = var.path
      healthy_threshold   = var.healthy_threshold
      unhealthy_threshold = var.unhealthy_threshold
      timeout             = var.timeout
      matcher             = var.matcher
    }

    depends_on = [
      aws_lb.alb
    ]
    lifecycle {
      create_before_destroy = true
    }    
}

resource "aws_lb_listener" "alb_listener" {
    provider = aws.current
    load_balancer_arn = aws_lb.alb.id
    port = var.app_port
    protocol = "HTTP"   

    default_action {
      target_group_arn = aws_lb_target_group.alb_tg.id
      type = "forward"
    }
}

resource "aws_alb_listener" "https_listener" {
    count         = var.create_https_listener ? 1 : 0  
    provider = aws.current
    load_balancer_arn = aws_lb.alb.id
    port = "443"
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = var.acm_certificate_arn
    default_action {
        target_group_arn = aws_lb_target_group.alb_tg.id
        type = "forward"
    }
} 