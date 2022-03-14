module "eventbridge" {
  source     = "terraform-aws-modules/eventbridge/aws"
  version    = "1.14.0"
  create_bus = false
  rules      = {
    ami-parameter-store = {
      description   = "Parameter Store AMI Change"
      event_pattern = jsonencode(
        {
          "source" : [
            "aws.ssm"
          ],
          "detail-type" : [
            "Parameter Store Change"
          ],
          "detail" : {
            "name" : [
              "win-ami"
            ],
            "operation" : [
              "Create",
              "Update"
            ]
          }
        }
      )
      enabled = true
    }
  }
  targets = {
    ami-parameter-store = [
      {
        name = "update-lc-and-asg"
        arn  = module.lambda.lambda_function_arn
      }, # Add Comma here when you add new target
      {
        name = var.sns_topic_name
        arn  = module.sns_topic.sns_topic_arn
      }
    ]
  }

  tags = {
    Name = "my-bus"
  }
}