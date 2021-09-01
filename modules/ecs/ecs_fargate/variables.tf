#Provider Block

# provider "aws" {
#   alias = "current"
# }

# provider "aws" {
#   alias = "shared"
# }

variable "enable_lb_deletion" {
  type = bool
  description = "Enable deletion protection for lb"
  default = true
}

variable "cluster_name" {
  type        = string
  description = "The name of the application and the family"
}

variable "app_image" {
  type = string 
  description = "Container image to be used for application in task definition file"
}

variable "ecs_cloudwatchlog_group" {
  description = "name of log group"
  type = string
  default = "/ecs/mmdafegbua"
}
variable "environment" {
  type = string
  description = "The application environment"
  default = "dev"
}

variable "fargate_cpu" {
  type = number
  description = "Fargate cpu allocation"
  default = 1024
}

variable "fargate_memory" {
  type = number
  description = "Fargate memory allocation"
  default = 2048
}

variable "app_port" {
  type = number
  description = "Application port"
  default = 80
}

variable "public_subnet_ids" {
  type = list(string)
  description = "IDs for public subnets"
}

variable "internal_loadbalancer" {
  type = bool
  default = false
}

variable "private_subnet_ids" {
  type = list(string)
  description = "IDs for private subnets"
}

variable "vpc_id" {
  type = string 
  description = "The id for the VPC where the ECS container instance should be deployed"
}

variable "cluster_id" {
  type = string 
  description = "Cluster ID"
}

variable "app_count" {
  type = string 
  description = "The number of instances of the task definition to place and keep running."
  default = 2
}

variable "aws_security_group_ecs_tasks_id" {
  type = string 
  description = "The ID of the security group for the ECS tasks"
}

variable "alb_sg_group" {
  type = list(string)
  description = "Security group for ALB"
}

variable "max_autoscaling" {
  type = number
  default = 2
}

variable "min_autoscaling" {
  type = number
  default = 1
}

variable "circuit_breaker" {
  type = string
  default = "enabled"
}

variable "acm_certificate_arn" {
  description = "The ARN for the certificate to be used"
  type = string
  default = ""
}

variable "create_https_listener" {
  description = "Choose whether to create https or not"
  type = bool
  default = false
}

variable "interval" {
  type = number
  description = "The appropriate amount of time between health checks of an individual target"
  default = 60
}

variable "matcher" {
  type = number
  description = "The HTTP codes to use when checking for a successful response from a target"
  default = 302
}

variable "healthy_threshold" {
  type = number
  description = "The number of consecutiv healthchecks successes required before declaring unhealthy"
  default = 5
}

variable "unhealthy_threshold" {
  type = number
  description = "The number of consecutive healthcheck failures"
  default = 3
}

variable "timeout" {
  type = number
  description = "The number of time in seconds between healthcheck of an individual target"
  default = 30
}

variable "path" {
  description = "Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB"
  type = string
  default = "/"
}
variable "scan_on_push" {
  description = "Set scan on push true or false"
  type = bool
  default = false
}

variable "database_name" {
  description = "database name"
  type = string
  default = ""
}

variable "app_environment" {
  description = "database environment for the application secrets"
  type = string
}

variable "secrets_name" {
  description = "secrets name for db"
  type = string
  default = ""
}

#s3
variable "force_destroy" {
    type    =   string
    default =   true
}

variable "bucket_name" {
    type    =   string
    description =   "name of bucket"
    default = ""
}
variable "region" {
    type    = string
    description =   "AWS region where resources are deployed"
}

variable "host_port" {
    type = number
    default = 8000
}

variable "container_port" {
    type = number
    default = 8000
}