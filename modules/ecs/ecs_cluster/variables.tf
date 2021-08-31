#Provider Block
provider "aws" {
  alias = "current"
}

provider "aws" {
  alias = "shared"
}

#Variables
variable "cluster_name" {
  type = string
  description = "name of cluster"
}

variable "cluster_tag_name" {
  type = string
  description = "Name tag given to cluster"
}

variable "environment" {
  type = string
  description = "Environment tag for cluster"
}