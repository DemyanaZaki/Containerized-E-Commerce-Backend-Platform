variable "instance_type"{ }


variable "security_group"{ type = string}

variable "vpc_id" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}

variable "ingress_rules" {
  type = map(number)

  default = {
    ssh   = 22
    http  = 80
    https = 443
  }
}