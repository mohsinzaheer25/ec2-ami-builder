data "local_file" "trust_policy" {
  filename = "${path.module}/policies/custom_trust_policy.json"
}

data "template_file" "lambda_policy" {
  template = file("${path.module}/policies/launch_configuration_lambda_policy.json")
  vars     = {
    region      = var.region
    account_id  = local.account_id
    lambda_name = var.lambda_name
  }
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4"

  name        = var.policy_name
  path        = "/"
  description = "Policy to modify launch template"

  policy = data.template_file.lambda_policy.rendered
  tags   = {
    Name         = var.policy_name,
    Created_By   = "Terraform"
    Terraform_At = "ec2-ami-builder/launch-configuration/role"
  }
}

module "iam_assumable_role" {
  source                   = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                  = "4.14.0"
  create_role              = true
  role_name                = var.role_name
  custom_role_trust_policy = data.local_file.trust_policy.content
  custom_role_policy_arns  = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    module.iam_policy.arn,
  ]
  tags = {
    Name         = var.role_name,
    Created_By   = "Terraform"
    Terraform_At = "ec2-ami-builder/launch-configuration/role"
  }
  depends_on = [module.iam_policy]
}

