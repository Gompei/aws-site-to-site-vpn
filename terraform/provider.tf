terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name = "example-aws-site-to-site-vpn"
    }
  }
}
