resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

module "subnets" {
  source               = "./subnets"
  vpc_id               = aws_vpc.main.id
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name
  environment          = var.environment
}

module "internet_gateway" {
  source       = "./internet_gateway"
  vpc_id       = aws_vpc.main.id
  project_name = var.project_name
  environment  = var.environment
}

module "nat_gateway" {
  source            = "./nat_gateway"
  public_subnet_ids = module.subnets.public_subnet_ids
  project_name      = var.project_name
  environment       = var.environment
}

module "route_tables" {
  source              = "./route_tables"
  vpc_id              = aws_vpc.main.id
  internet_gateway_id = module.internet_gateway.id
  nat_gateway_ids     = module.nat_gateway.nat_gateway_ids
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  project_name        = var.project_name
  environment         = var.environment
}