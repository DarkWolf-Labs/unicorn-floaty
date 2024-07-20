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
                      sudo apt-get update
                      sudo apt-get upgrade -y
                      sudo apt-get install -y openjdk-11-jre-headless
                      sudo apt install unzip
                      sudo apt-get install default-jre -y
                      sudo wget https://github.com/traccar/traccar/releases/download/v6.2/traccar-linux-64-6.2.zip
                      sudo unzip traccar-linux-64-6.2.zip -d /opt/
                      cd /opt
                      sudo ./traccar.run
                      sudo systemctl start traccar
                      EOF
  root_volume_size  = 20
}