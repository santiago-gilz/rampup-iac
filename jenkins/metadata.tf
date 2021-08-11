terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ramp-up-devops-psl"
    key    = "santiago.gilz/terraform/rampup-jenkins-tfstate"
    region = "us-west-1"
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.AWS_REGION
}
