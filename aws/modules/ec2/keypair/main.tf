module "keypair" {
  source           = "./keypair"
  key_name         = var.key_name
  private_key_path = var.private_key_path
}

# You can add other EC2-related resources here in the future