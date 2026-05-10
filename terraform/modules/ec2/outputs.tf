
output "vpc_id" {
  value = var.vpc_id
}

output "public_subnet_id" {
  value = var.private_subnet_id
}

output "app_sg" {
  value = aws_security_group.app_sg.id
}


output "private_subnet_id" {
  value = var.private_subnet_id
}

