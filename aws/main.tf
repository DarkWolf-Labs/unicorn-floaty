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

module "keypair" {
  source           = "./modules/ec2/keypair"
  key_name         = "${var.project_name}-${var.environment}-key"
  private_key_path = "${path.module}/private_key.pem"
}

module "security_group" {
  source       = "./modules/ec2/security_groups"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "ubuntu_server" {
  source            = "./playbooks/ubuntu"
  project_name      = var.project_name
  environment       = var.environment
  ami_id            = var.ubuntu_ami_id
  instance_type     = var.instance_type
  key_name          = module.keypair.key_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.ubuntu_security_group_id
}

module "traccar_server" {
  source            = "./playbooks/traccar"
  project_name      = var.project_name
  environment       = var.environment
  ami_id            = var.debian_ami_id
  instance_type     = var.instance_type
  key_name          = module.keypair.key_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.traccar_security_group_id
}

module "openvpn_server" {
  source            = "./playbooks/openvpn"
  project_name      = var.project_name
  environment       = var.environment
  ami_id            = var.debian_ami_id
  instance_type     = var.instance_type
  key_name          = module.keypair.key_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.openvpn_security_group_id
}

module "matrix_server" {
  source            = "./playbooks/matrix"
  project_name      = var.project_name
  environment       = var.environment
  ami_id            = var.debian_ami_id
  instance_type     = var.instance_type
  key_name          = module.keypair.key_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.matrix_security_group_id
  private_key_path  = module.keypair.private_key_path
  matrix_domain     = var.matrix_domain
  auto_start_matrix = var.auto_start_matrix
}