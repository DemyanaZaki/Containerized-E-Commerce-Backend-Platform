###create_security_group

 resource "aws_security_group" "web_sg" {
  name = var.security_group
  vpc_id = var.vpc_id
}



resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.web_sg.id
}



###Create_AMI
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

###Create_Public_Instance

resource "aws_instance" "public_ec2" {
  count = 5
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

   user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>public instance</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}

###Create_Private_Instance

resource "aws_instance" "apache_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

   user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>private instance</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "private instance"
  }
}