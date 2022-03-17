#data "aws_caller_identity" "current" {}
#
#locals {
#  account_id = data.aws_caller_identity.current.account_id
#}

#resource "aws_sns_topic_subscription" "email_notification" {
#  topic_arn = "arn:aws:sns:${var.region}:${local.account_id}:ec2-windows-ami-update"
#  protocol  = "email"
#  endpoint  = "dl-distlistdtsdevops@carnival.com"
#}


## We might not need below block if win update sns works and need only above block.

data "template_file" "sns_policy" {
  template = file("${path.module}/policies/sns_policy.json")
  vars     = {
    region     = var.region
    account_id = local.account_id
    topic_name = var.sns_topic_name
  }
}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 3.0"

  name   = var.sns_topic_name
  policy = data.template_file.sns_policy.rendered

  tags = {
    Name         = var.sns_topic_name
    Created_By   = "Terraform"
    Terraform_At = "ec2-ami-builder/update-lc-asg/sns"
  }
}

resource "aws_sns_topic_subscription" "email_notification" {
  topic_arn = module.sns_topic.sns_topic_arn
  protocol  = "email"
  endpoint  = "dl-distlistdtsdevops@carnival.com"
}


