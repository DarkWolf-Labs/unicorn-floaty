module "matrix_server" {
  source            = "../../modules/ec2/instance"
  project_name      = var.project_name
  environment       = var.environment
  instance_name     = "matrix-server"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = var.subnet_id
  security_group_id = var.security_group_id
  os_user           = "admin"
  user_data         = <<-EOF
    #!/bin/bash
    set -ex

    # Update and install prerequisites
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg

    # Set up Docker repository
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add admin user to docker group
    sudo usermod -aG docker admin

    # Make sure to turn on service and make sure it starts on boot
    sudo systemctl start docker
    sudo systemctl enable docker

    # Move docker compose from tmp to home
    cd /tmp
    sudo mkdir matrix
    sudo chown admin:admin /tmp/matrix
    sudo mv /tmp/docker-compose.yml /tmp/matrix/
    sudo mv /tmp/matrix/ /home/matrix/
    cd /home/matrix/
    # The server name will have to be the IP address of the machine in dev but you can use a FQDN in production
    docker run --rm -v ./data:/data -e SYNAPSE_SERVER_NAME=domain.com -e SYNAPSE_REPORT_STATS=yes matrixdotorg/synapse:latest generate
    docker compose up -d

    echo "Setup completed successfully!"
  EOF
}

resource "null_resource" "copy_docker_compose" {
  depends_on = [module.matrix_server]

  provisioner "file" {
    source      = "${path.module}/files/docker-compose.yml"
    destination = "/tmp/docker-compose.yml"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.private_key_path)
      host        = module.matrix_server.public_ip
    }
  }
}

variable "private_key_path" {
  description = "Path to the private key used for SSH access"
  type        = string
}
