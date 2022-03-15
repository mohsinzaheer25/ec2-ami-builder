variable "region" {
  type        = string
  description = "Region for the environment."
}

variable "parameter_store_name" {
  type        = string
  description = "Name of Parameter Store"
}

variable "parameter_store_value" {
  type        = string
  description = "Value of Parameter Store"
}

variable "eventbridge_rule_name" {
  type        = string
  description = "Name of Event Bridge Rule"
}

variable "role_name" {
  type        = string
  description = "Name of the role."
}

variable "policy_name" {
  type        = string
  description = "Name of the policy."
}

variable "lambda_name" {
  type        = string
  description = "Name of lambda function"
}

variable "sns_topic_name" {
  type        = string
  description = "Name of the SNS Topic."
}

variable "launch_template_id" {
  type        = string
  description = "ID of Launch Template."
}

variable "targetASG" {
  type        = string
  description = "Name of target asg."
}