region                      = "us-east-1"
role_name                   = "ec2_win_ami_builder_role"
builder_role_iam_policy_arn = [
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
]