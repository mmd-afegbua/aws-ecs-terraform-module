module "vpc_for_ecs_fargate" {
  providers = {
    aws.current = aws.beta-east-1
  }
  source = "./modules/vpc"
  vpc_tag_name = "test-vpc"
  number_of_private_subnets = 2
  number_of_public_subnets = 2
  private_subnet_tag_name = "${local.cluster_name}-private-subnet"
  public_subnet_tag_name = "${local.cluster_name}-public-subnet"
  environment = local.environment
  security_group_lb_name = "${local.cluster_name}-alb-sg"
  security_group_ecs_tasks_name = "${local.cluster_name}-ecs-tasks-sg"
  app_port = 8080
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  region = "us-east-1"
}

# ECS cluster
module "ecs_cluster" {
  providers = {
    aws.current = aws.beta-east-1
  }
  source = "./modules/ecs/ecs_cluster"
  cluster_name = local.cluster_name
  cluster_tag_name = "${local.cluster_name}-${local.environment}-cluster"
  environment = local.environment
}

# ECS task definition and service
module "ecs_task_definition_and_service" {
  # Task definition and NLB
  providers = {
    aws.current = aws.beta-east-1
  }
  source = "./modules/ecs/ecs_fargate"
  cluster_name = local.cluster_name


  vpc_id = module.vpc_for_ecs_fargate.vpc_id
  environment = local.environment
  app_image = local.app_image
  app_port = local.app_port
  app_environment = local.environment
  alb_sg_group = module.vpc_for_ecs_fargate.alb_security_group_id

  #HTTPS
  create_https_listener = false #Set to true if you have certicicate provisioned.
  acm_certificate_arn = ""

  # Service
  cluster_id = module.ecs_cluster.cluster_id
  app_count = var.app_count
  aws_security_group_ecs_tasks_id = module.vpc_for_ecs_fargate.ecs_tasks_security_group_id
  public_subnet_ids = module.vpc_for_ecs_fargate.public_subnet_ids
  private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
}


# module "main_tool_dns" {
#   providers = {
#     aws.current = aws.beta-east-1
#    }
#   source = "./modules/dns"
#   environment = var.environment
#   domain_name = ""
#   load_balancer_arn = module.ecs_task_definition_and_service.alb_arn
#   target_group_arn = module.ecs_task_definition_and_service.target_group_arn
#   zone_id = var.zone_id
# }

# API Gateway and VPC link
# module "api_gateway" {
  # providers = {
  #   aws.current = aws.beta-east-1
  # }
#   source = "./modules/api_gateway"
#   cluster_name = "${var.cluster_name}-${var.environment}"
#   input_integration_type = "HTTP_PROXY"
#   path_part = "{proxy+}"
#   app_port = var.app_port
#   nlb_dns_address = module.ecs_task_definition_and_service.nlb_dns_address
#   nlb_arn = module.ecs_task_definition_and_service.nlb_arn
#   environment = var.environment
# }