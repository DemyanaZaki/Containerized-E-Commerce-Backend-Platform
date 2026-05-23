output "vpc_id" {
  value = var.vpc_id
}

output "public_subnet_id" {
  value = var.public_subnet_id
}

output "app_sg" {
  value = aws_security_group.app_sg.id
}

output "private_subnet_id" {
  value = var.private_subnet_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}
