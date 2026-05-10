variable "vpc_id" {}

variable "private_subnet_ids" {}

variable "ec2_security_group_id" {}

variable "db_username" {}

variable "db_password" {
  sensitive = true
}