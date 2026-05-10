# RDS SECURITY GROUP

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL access only from EC2 SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

# DB SUBNET GROUP

resource "aws_db_subnet_group" "main" {
  name       = "mysql-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "mysql-db-subnet-group"
  }
}


# MYSQL RDS INSTANCE

resource "aws_db_instance" "mysql" {
  identifier             = "mysql-rds"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"

  username               = var.db_username
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = true

  storage_type           = "gp2"

  backup_retention_period = 7

  tags = {
    Name = "mysql-rds"
  }
}