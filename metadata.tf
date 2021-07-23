terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ramp-up-devops-psl"
    key    = "santiago.gilz/terraform/rampup-tfstate"
    region = "us-west-1"
  }

  required_version = ">= 1.0"
}

provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  region     = var.AWS_REGION
  secret_key = var.AWS_SECRET_KEY
}
