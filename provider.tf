terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.27.0"
    }
  }
}


#Secret Manager Data Sources
#Dev
data "aws_secretsmanager_secret_version" "test_creds" {
    secret_id = "test/sts"
}

#Regions
locals {
  aws_regions = {
    "r0"  = "us-east-1"      # N Virginia, USA
    "r1"  = "eu-west-1"      # Dublin, Ireland
    "r2"  = "us-west-1"      # N California, USA
  }
}

#Get Credentials from Secret manager in JSON format but decode them
#change to staging_creds, alpha_creds or prod_creds. Secrets are stored in AWSTerraform Account
locals {
  aws_env_creds = jsondecode(
    data.aws_secretsmanager_secret_version.test_creds.secret_string
  )
}

#Load sts creds into: a = access key ID, s = secret key, t = token in case of sts role
locals {
  gsuite_dev = {
    a = local.aws_env_creds.AWS_ACCESS_KEY_ID
    s = local.aws_env_creds.AWS_SECRET_ACCESS_KEY
  }
}

#Declare Initial Region, before switching to sepcific environment regions
provider "aws" {
  region = var.region
}

#The Providers list below can be appended
################################################################################
# AWS Providers Dev

provider "aws" {
  alias      = "dev-east-1"
  access_key = local.gsuite_dev["a"]
  secret_key = local.gsuite_dev["s"]
  region     = local.aws_regions["r0"]
}