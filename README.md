# aws-ecs-terraform-module

# Terraform Module for Elastic Container Service - Fargate.
Resources declared are:
```
1.VPC:
    * VPC Endpoints
    * Natgateway
    * Subnets
    * Internet Gateway
    * Public and Private Router
    * Security Group
2.ECS Cluster
3.ECS Fargate:
    * ALB
    * ECS Task Definition
    * ECS Service
```

For efficient implementaton, you need a minimum of three files in your application folder:
main.tf
provider.tf

HOW TO USE IT

Ensure you set up necessary backends and Makefile befor implementing.
### Example maim.yaml
```
module "vpc_for_ecs_fargate" {
  providers = {
    aws.current = aws.current
  }
  source = "./vpc"
  vpc_tag_name = "${var.cluster_name}-vpc"
  number_of_private_subnets = 2
  number_of_public_subnets = 2
  private_subnet_tag_name = "${var.cluster_name}-private-subnet"
  public_subnet_tag_name = "${var.cluster_name}-public-subnet"
  environment = var.environment
  security_group_lb_name = "${var.cluster_name}-alb-sg"
  security_group_ecs_tasks_name = "${var.cluster_name}-ecs-tasks-sg"
  app_port = var.app_port
  availability_zones = var.availability_zones
  region = var.region
}

#ECS cluster
module "ecs_cluster" {
  providers = {
    aws.current = aws.current
  }
  source = "./ecs_cluster"
  cluster_name = "${var.cluster_name}-${var.environment}-cluster"
  cluster_tag_name = "${var.cluster_name}-${var.environment}-cluster"
  environment = "dev"
}

#ECS task definition and service
module "ecs_task_definition_and_service" {
  #Task definition and NLB
  providers = {
    aws.current = aws.current
  }
  source = "./ecs_fargate"
  cluster_name = "${var.cluster_name}-${var.environment}"
  app_image = var.app_image
  fargate_cpu                 = 1024
  fargate_memory              = 2048
  app_port = var.app_port
  vpc_id = module.vpc_for_ecs_fargate.vpc_id
  environment = var.environment
  enable_lb_deletion = false
  internal_loadbalancer = false
  alb_sg_group = module.vpc_for_ecs_fargate.alb_security_group_id
  #Service
  cluster_id = module.ecs_cluster.cluster_id
  app_count = var.app_count
  aws_security_group_ecs_tasks_id = module.vpc_for_ecs_fargate.ecs_tasks_security_group_id
  public_subnet_ids = module.vpc_for_ecs_fargate.public_subnet_ids
  private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
}
```
