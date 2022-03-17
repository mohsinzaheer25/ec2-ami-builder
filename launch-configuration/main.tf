terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  //  backend "s3"{
  //    bucket = "replacewithbucketname"
  //    key = "ec2-ami-builder.tfstate"
  //    region = var.region
  //    dynamodb_table = "ec2-ami-builder-statefile-lock"
  //    encrypt = true
  //  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  #profile = "${terraform.workspace}-profile"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}