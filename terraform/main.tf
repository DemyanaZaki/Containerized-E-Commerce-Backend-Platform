# 1. IAM Module [cite: 191]
module "iam" {
  source = "./modules/iam"
}
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  vpc_name           = "main-vpc"

  Public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"

  availability_zone  = "us-east-1a"

  igw_name = "main-igw"
  nat_gw   = "main-nat-gateway"
}



module "ec2" {
  source = "./modules/ec2"

  vpc_id = module.vpc.vpc_id

  # public subnet (from vpc module outputs)
  public_subnet_id = module.vpc.public_subnet_id

  # private subnet(s)
  private_subnet_id   = module.vpc.private_subnet_id
  private_subnet_2_id = module.vpc.private_subnet_2_id

  instance_type = "t2.micro"

  key_name = "my-key"

  ecr_repo_url = "242201281496.dkr.ecr.us-east-1.amazonaws.com/myecr"
}


