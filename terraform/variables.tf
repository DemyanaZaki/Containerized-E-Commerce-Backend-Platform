variable "region" {
  default = "us-east-1" 
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

variable "ecr_repo_url" {
  description = "The URL of the ECR repository"
  type        = string
}