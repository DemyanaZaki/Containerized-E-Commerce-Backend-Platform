########################################
# Bastion Outputs
########################################

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_id" {
  value = aws_instance.bastion.id
}

########################################
# Security Groups
########################################

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

########################################
# ALB
########################################

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

########################################
# ASG
########################################

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app_asg.name
}