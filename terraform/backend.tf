terraform {
  backend "s3" {
    bucket       = "shopflow-terraform-state-dnt"
    key          = "stage/data-stores/mysql/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true # Enables native S3 locking [cite: 23]
    encrypt      = true
  }
}