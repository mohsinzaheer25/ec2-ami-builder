variable "region" {
  type        = string
  description = "Region for the environment."
}

variable "builder_role_iam_policy_arn" {
  type        = list
  description = "Builder IAM Policy to be attached to role"
}


variable "role_name" {
  type        = string
  description = "Name of the role."
}