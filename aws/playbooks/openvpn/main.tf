module "openvpn_server" {
  source            = "../../modules/ec2/instance"
  project_name      = var.project_name
  environment       = var.environment
  instance_name     = "openvpn-server"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = var.subnet_id
  security_group_id = var.security_group_id
  os_user           = "admin"
  user_data         = <<-EOF
                      #!/bin/bash
                      apt-get update
                      apt-get upgrade -y
                      apt-get install -y openvpn easy-rsa
                      # Add OpenVPN setup steps here
                      EOF
}