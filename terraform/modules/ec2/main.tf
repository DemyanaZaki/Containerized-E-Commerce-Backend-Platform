########################################
# Security Groups
########################################

# Bastion SG
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.bastion_sg.id
}

########################################
# ALB SG
########################################

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.alb_sg.id
}

########################################
# App SG
########################################

resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "app-sg"
  }
}

# HTTP from ALB
resource "aws_security_group_rule" "app_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id = aws_security_group.app_sg.id
}

# SSH from Bastion
resource "aws_security_group_rule" "app_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id

  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "app_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.app_sg.id
}

########################################
# AMI
########################################

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

########################################
# Bastion Host
########################################

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "bastion-host"
  }
}



########################################
# Launch Template
########################################

resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  iam_instance_profile {
    name = var.ec2_instance_profile
  }

user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group so it can run docker without sudo
usermod -aG docker ec2-user

# Authenticate Docker with ECR using the instance IAM role
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin ${var.ecr_repo_url}

# Pull the latest image from ECR
docker pull ${var.ecr_repo_url}:latest

# Run the container, mapping host port 80 to container port 80
docker run -d \
  --name shopflow \
  --restart always \
  -p 8080:80 \
  ${var.ecr_repo_url}:latest
EOF
)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "private-instance"
    }
  }
}

########################################
# Target Group
########################################

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id


  lifecycle {
    create_before_destroy = true
  }


  health_check {
    path                = "/"
    port                = "8080" # <--- Ensure health checks go to 8080 as well
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }


}




########################################
# ALB
########################################

resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    var.public_subnet_id,
    var.public_subnet_id2
  ]

  tags = {
    Name = "app-alb"
  }
}

########################################
# Listener
########################################

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

########################################
# Auto Scaling Group
########################################

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = [
  var.private_subnet_id,
  var.private_subnet_id2
]

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "private-instance"
    propagate_at_launch = true
  }
}