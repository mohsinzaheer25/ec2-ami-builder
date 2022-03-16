resource "aws_ssm_parameter" "ami_update_param" {
  name  = var.parameter_store_name
  type  = "String"
  value = var.parameter_store_value
  tags  = {
    Name         = var.parameter_store_name,
    Created_By   = "Terraform"
    Terraform_At = "ec2-ami-builder/launch-configuration/parameter-store"
  }
}