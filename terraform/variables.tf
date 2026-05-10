variable "instance_type" {
  type    = string
  
}

variable "key_name" {
  type = string
}

variable "ecr_repo_url" {
  type = string
}

variable "db_username" {}

variable "db_password" {
  sensitive = true
}
variable "region" {
  type = string
}