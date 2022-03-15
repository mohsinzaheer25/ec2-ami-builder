output "sns_topic_arn" {
  value = module.sns_topic.sns_topic_arn
}

output "sns_topic_id" {
  value = module.sns_topic.sns_topic_id
}

output "policy_arn" {
  value = module.iam_policy.arn
}

output "eventbridge_rule_arn" {
  value = module.eventbridge.eventbridge_rule_arns
}