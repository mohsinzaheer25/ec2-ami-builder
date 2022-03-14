resource "aws_ssm_parameter" "win_ami" {
  name  = var.parameter_store_name
  type  = "String"
  value = var.parameter_store_value
  tags  = {
    Name         = var.parameter_store_name,
    Created_By   = "Terraform"
    Terraform_At = "ec2-ami-builder/parameter-store"
  }
}