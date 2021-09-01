resource "aws_ecs_task_definition" "main" {
    family = var.cluster_name
    task_role_arn = aws_iam_role.ecs_task_role.arn
    execution_role_arn = aws_iam_role.ecs_main_tasks.arn
    network_mode = "awsvpc"
    requires_compatibilities = [ "FARGATE" ]
    cpu = var.fargate_cpu
    memory = var.fargate_memory
    container_definitions = jsonencode([
        {
            name : var.cluster_name
            image : var.app_image
            cpu : var.fargate_cpu,
            memory : var.fargate_memory,
            networkMode : "awsvpc",
            logConfiguration : {
                logDriver: "awslogs",
                options: {
                    "awslogs-group": "/ecs/main",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                    }
                },
            environment : [
                {
                    "name": "DB_NAME",
                    "value": var.database_name
                },
                {
                    "name": "ENVIRONMENT",
                    "value": var.app_environment
                },
                {
                    "name": "SECRET_MANAGER_NAME",
                    "value": var.secrets_name
                }
            ],
            portMappings : [
                {
                    containerPort : var.container_port
                    protocol : "tcp",
                    hostPort : var.host_port
                }
            ]
        }
    ])
}