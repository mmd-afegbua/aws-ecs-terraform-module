terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.27.0"
    }
  }
}


provider "aws" {
 alias                   = "current" 
 region                  = "us-west-1"
}