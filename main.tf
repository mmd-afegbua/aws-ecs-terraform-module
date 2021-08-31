module "vpc_for_ecs_fargate" {
  providers = {
    aws.current = aws.beta-east-1
  }
  source = "./vpc"
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