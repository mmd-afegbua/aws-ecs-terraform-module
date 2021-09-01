# provider "aws" {
#   alias = "current"
# }

# provider "aws" {
#   alias = "shared"
# }

variable "environment" {
  type = string
  description = "Environment to deploy to"
}

variable "domain_name" {
  type = string
  description = "The DNS domain name of the application"
}

variable "load_balancer_arn" {
  type = string
  description = "The ARN of Application Load Balancer"
}

variable "target_group_arn" {
  type = string
  description = "AL Target group arn"  
}

variable "zone_id" {
  type = string
  description = "Route53 Zone ID"  
}

variable "record_ttl" {
  type = number
  default = 120  
}