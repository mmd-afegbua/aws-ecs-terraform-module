terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.27.0"
    }
  }
}

##############################################################################
# AWS STS Credentials Beta

locals {
  aws_regions = {
    "r0"  = "us-east-1"      # N Virginia, USA
    "r1"  = "eu-west-1"      # Dublin, Ireland
    "r2"  = "us-west-1"      # N California, USA
  }
}

#TODO Secret Manager
locals {
  gsuite_beta = {
    a = ""
    s = ""
  }
}

################################################################################
# AWS Providers Beta

provider "aws" {
  alias      = "beta-east-1"
  access_key = local.gsuite_beta["a"]
  secret_key = local.gsuite_beta["s"]
  region     = local.aws_regions["r0"]
}

provider "aws" {
  alias      = "beta-west-1"
  access_key = local.gsuite_beta["a"]
  secret_key = local.gsuite_beta["s"]
#  token      = local.gsuite_beta["t"]
  region     = local.aws_regions["r1"]
}