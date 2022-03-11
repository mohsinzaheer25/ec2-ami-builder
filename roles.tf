resource "aws_iam_role" "ami_build_role" {
  name               = var.role_name
  assume_role_policy = jsonencode(
    {
      Version   = "2012-10-17"
      Statement = [
        {
          Action    = "sts:AssumeRole"
          Effect    = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  count      = length(var.builder_role_iam_policy_arn)
  policy_arn = var.builder_role_iam_policy_arn[count.index]
  role       = aws_iam_role.ami_build_role.name
}
