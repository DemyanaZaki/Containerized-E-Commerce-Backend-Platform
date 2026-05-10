<<<<<<< Updated upstream
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


module "ec2"{
    source = "./modules/ec2"
    vpc_id = module.vpc.vpc_id
    public_subnet_id = module.vpc.public_subnet_id
    private_subnet_id = module.vpc.private_subnet_id
    instance_type = "t3.micro"
    security_group = "web_sg"

}


=======
# 1. IAM Module [cite: 191]
module "iam" {
  source = "./modules/iam"
}

# 2. VPC Module [cite: 139]
module "vpc" {
  source = "./modules/vpc"
}

# 3. RDS Module [cite: 179]
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.ec2.app_security_group_id
  db_password        = var.db_password
}

# 4. EC2 & ASG Module [cite: 150]
module "ec2" {
  source               = "./modules/ec2"
  vpc_id               = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnet_id
  private_subnet_id    = module.vpc.private_subnet_id
  iam_instance_profile = module.iam.ec2_instance_profile_name [cite: 91, 193]
  ecr_repo_url         = var.ecr_repo_url
}
>>>>>>> Stashed changes
