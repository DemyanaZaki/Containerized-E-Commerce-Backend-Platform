variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_security_group_id" {
   type = string 
}

variable "db_username" {}

variable "db_password" {
  sensitive = true
}