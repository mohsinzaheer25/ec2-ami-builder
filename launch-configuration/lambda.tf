module "lambda" {
  source           = "terraform-aws-modules/lambda/aws"
  version          = "2.35.0"
  function_name    = var.lambda_name
  description      = "Lambda function to update windows ami in launch configuration and asg template"
  handler          = "launch-configuration.lambda_handler"
  runtime          = "python3.7"
  timeout          = 300
  lambda_role      = module.iam_assumable_role.iam_role_arn
  create_role      = false
  source_path      = "${path.module}/function/src/launch-configuration.py"
  publish          = true
  allowed_triggers = {
    WIN_SNS = {
      principal  = "sns.amazonaws.com"
      source_arn = "arn:aws:sns:us-east-1:801119661308:ec2-windows-ami-update"
      # ^^^ This value is fix won't change per aws account
    },
    Linux_SNS = {
      principal  = "sns.amazonaws.com"
      source_arn = "arn:aws:sns:us-east-1:137112412989:amazon-linux-2-ami-updates"
      # ^^^ This value is fix won't change per aws account
    }
  }

  environment_variables = {
    eks_version       = var.eks_version
    linux_asg_names   = var.linux_asg_names
    windows_asg_names = var.windows_asg_names
  }

  destination_on_failure = ""

  tags = {
    Name         = var.lambda_name,
    Created_By   = "Terraform"
    Terraform_At = "ec2-ami-builder/launch-configuration/lambda"
  }
}