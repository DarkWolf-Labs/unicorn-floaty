module "instance" {
  source           = "./instance"
  project_name     = var.project_name
  environment      = var.environment
  instance_type    = var.instance_type
  key_name         = var.key_name
  subnet_id        = var.subnet_id
  vpc_id           = var.vpc_id
  ami_id           = var.ami_id
  security_group_id = module.security_group.security_group_id
}

module "keypair" {
  source           = "./keypair"
  key_name         = var.key_name
  private_key_path = var.private_key_path
}

module "security_group" {
  source       = "./security_groups"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = var.vpc_id
}