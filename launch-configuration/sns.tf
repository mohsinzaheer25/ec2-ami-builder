resource "aws_sns_topic_subscription" "win_trigger" {
  topic_arn = "arn:aws:sns:us-east-1:801119661308:ec2-windows-ami-update"
  # ^^^ This value is fix won't change per aws account
  protocol  = "lambda"
  endpoint  = module.lambda.lambda_function_arn
}

resource "aws_sns_topic_subscription" "linux_trigger" {
  topic_arn = "arn:aws:sns:us-east-1:137112412989:amazon-linux-2-ami-updates"
  # ^^^ This value is fix won't change per aws account
  protocol  = "lambda"
  endpoint  = module.lambda.lambda_function_arn
}

#data "template_file" "sns_policy" {
#  template = file("${path.module}/policies/sns_policy.json")
#  vars     = {
#    region     = var.region
#    account_id = local.account_id
#    topic_name = var.sns_topic_name
#  }
#}

#module "sns_topic" {
#  source  = "terraform-aws-modules/sns/aws"
#  version = "~> 3.0"
#
#  name   = var.sns_topic_name
#  policy = data.template_file.sns_policy.rendered
#
#  tags = {
#    Name         = var.sns_topic_name
#    Created_By   = "Terraform"
#    Terraform_At = "ec2-ami-builder/sns"
#  }
#}
#
#resource "aws_sns_topic_subscription" "email_notification" {
#  topic_arn = module.sns_topic.sns_topic_arn
#  protocol  = "email"
#  endpoint  = "dl-distlistdtsdevops@carnival.com"
#}
