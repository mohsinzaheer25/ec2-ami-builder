variable "region" {
  type        = string
  description = "Region for the environment."
}

variable "lambda_name" {
  type        = string
  description = "Name of lambda function"
}

variable "role_name" {
  type        = string
  description = "Name of the role."
}

variable "policy_name" {
  type        = string
  description = "Name of the policy."
}

variable "eks_version" {
  type        = string
  description = "Version of EKS."
}

variable "linux_asg_names" {
  type        = string
  description = "List of Linux Auto Scaling Group Name and command separated."
}

variable "windows_asg_names" {
  type        = string
  description = "List of Windows Auto Scaling Group Name and command separated."
}

variable "parameter_store_name" {
  type        = string
  description = "Name of Parameter Store"
}

variable "parameter_store_value" {
  type        = string
  description = "Value of Parameter Store"
}
