provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name
  environment          = var.environment
}

module "ec2" {
  source           = "./modules/ec2"
  key_name         = "${var.project_name}-${var.environment}-key"
  private_key_path = "${path.module}/private_key.pem"
}

module "matrix_server" {
  source           = "./modules/matrix_server"
  instance_type    = "t2.micro"
  key_name         = module.ec2.key_name           # Use the key_name from the EC2 module
  private_key_path = module.ec2.private_key_path   # Use the private_key_path from the EC2 module
  subnet_id        = module.vpc.public_subnet_ids[0]
  vpc_id           = module.vpc.vpc_id
  project_name     = var.project_name
}