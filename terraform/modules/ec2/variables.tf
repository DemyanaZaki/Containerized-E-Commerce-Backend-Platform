variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}



variable "private_subnet_id" {
  type = string
}


variable "instance_type" {
  type    = string
  
}

variable "key_name" {
  type = string
}

variable "ecr_repo_url" {
  type = string
}
variable "ec2_instance_profile" {
  type = string
}

variable "ingress_rules" {
  type = map(number)

  default = {
    ssh   = 22
    http  = 80
    https = 443
  }
}