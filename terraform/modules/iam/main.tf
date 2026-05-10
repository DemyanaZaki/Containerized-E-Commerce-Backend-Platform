# --- Developers Group ---
resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group_policy_attachment" "dev_ecr" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser" # ECR Push/Pull
}

resource "aws_iam_group_policy_attachment" "dev_ec2_read" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "dev_s3_read" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# --- Operators Group ---
resource "aws_iam_group" "operators" {
  name = "Operators"
}

resource "aws_iam_group_policy_attachment" "ops_ec2_full" {
  group      = aws_iam_group.operators.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "ops_rds_read" {
  group      = aws_iam_group.operators.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}

# --- Viewers Group ---
resource "aws_iam_group" "viewers" {
  name = "Viewers"
}

resource "aws_iam_group_policy_attachment" "viewer_read_only" {
  group      = aws_iam_group.viewers.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# --- Admins Group ---
resource "aws_iam_group" "admins" {
  name = "Admins"
}

resource "aws_iam_group_policy_attachment" "admin_full_access" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}









resource "aws_iam_role" "ec2_app_role" {
  name = "ShopFlow-EC2-App-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Pull images from ECR
resource "aws_iam_role_policy_attachment" "ec2_ecr_pull" {
  role       = aws_iam_role.ec2_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Send logs to CloudWatch
resource "aws_iam_role_policy_attachment" "ec2_cw_logs" {
  role       = aws_iam_role.ec2_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile to be used in the EC2 Launch Template
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ShopFlow-EC2-Profile"
  role = aws_iam_role.ec2_app_role.name
}