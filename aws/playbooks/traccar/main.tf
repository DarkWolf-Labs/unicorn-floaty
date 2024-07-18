module "traccar_server" {
  source            = "../../modules/ec2/instance"
  project_name      = var.project_name
  environment       = var.environment
  instance_name     = "traccar-server"
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
                      apt-get install -y openjdk-11-jre-headless
                      wget https://github.com/traccar/traccar/releases/download/v4.15/traccar-linux-64-4.15.zip
                      unzip traccar-linux-64-4.15.zip
                      ./traccar.run
                      EOF
  root_volume_size  = 20
}