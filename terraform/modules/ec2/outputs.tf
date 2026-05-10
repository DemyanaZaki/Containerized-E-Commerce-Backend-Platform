output "instance_public_ips" {
  value = aws_instance.public_ec2[*].public_ip
}

output "private_ip" {
  value = aws_instance.apache_ec2.private_ip
}


