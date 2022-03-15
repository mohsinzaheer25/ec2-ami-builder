module "lambda" {
  source           = "terraform-aws-modules/lambda/aws"
  version          = "2.35.0"
  function_name    = var.lambda_name
  description      = "Lambda function to update windows ami in launch configuration and asg template"
  handler          = "update-lc-asg.lambda_handler"
  runtime          = "python3.7"
  timeout          = 300
  lambda_role      = module.iam_assumable_role.iam_role_arn
  create_role      = false
  source_path      = "${path.module}/function/src/update-lc-asg.py"
  publish          = true
  allowed_triggers = {
    EB = {
      principal  = "events.amazonaws.com"
      source_arn = "arn:aws:events:${var.region}:${local.account_id}:rule/${var.eventbridge_rule_name}"
    }
  }

  environment_variables = {
    launch_template_id = var.launch_template_id
    targetASG          = var.targetASG
  }

  tags = {
    Name         = var.lambda_name,
    Created_By   = "Terraform"
    Terraform_At = "ec2-ami-builder/lambda"
  }
}