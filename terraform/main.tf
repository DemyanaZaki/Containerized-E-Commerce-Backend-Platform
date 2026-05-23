
module "iam" {
  source = "./modules/iam"
}
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = "10.0.0.0/16"
  vpc_name            = "main-vpc"

  Public_subnet_cidr  = "10.0.1.0/24"
  public_subnet_cidr2 = "10.0.4.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet_cidr2 = "10.0.3.0/24"

  availability_zone = "us-east-1a"

  igw_name = "main-igw"
  nat_gw   = "main-nat-gateway"
}



module "ec2" {
  source               = "./modules/ec2"
  ec2_instance_profile = module.iam.ec2_instance_profile_name
  vpc_id               = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnet_id
  public_subnet_id2    = module.vpc.public_subnet_id2
  private_subnet_id    = module.vpc.private_subnet_id
  private_subnet_id2   = module.vpc.private_subnet_id2
  instance_type        = var.instance_type
  key_name             = var.key_name
  ecr_repo_url         = var.ecr_repo_url
}



module "rds" {
  source = "./modules/rds"

  vpc_id                = module.vpc.vpc_id
    private_subnet_ids    = [
    module.vpc.private_subnet_id,
    module.vpc.private_subnet_id2   
  ]
  ec2_security_group_id = module.ec2.app_sg

  db_username = var.db_username
  db_password = var.db_password
}




