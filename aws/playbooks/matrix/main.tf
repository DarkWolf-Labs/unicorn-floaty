data "aws_ami" "debian_12" {
  most_recent = true
  owners      = ["136693071363"] # Debian

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "matrix_server" {
  ami           = data.aws_ami.debian_12.id
  instance_type = var.instance_type
  key_name      = var.key_name  # Use the key_name from the EC2 module
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.matrix_sg.id]

  tags = {
    Name = "${var.project_name}-matrix-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io docker-compose
              systemctl start docker
              systemctl enable docker
              usermod -aG docker admin
              mkdir -p /opt/matrix
              chown admin:admin /opt/matrix
              EOF

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
}

resource "aws_security_group" "matrix_sg" {
  name        = "${var.project_name}-matrix-sg"
  description = "Security group for Matrix chat server"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "matrix_ip" {
  instance = aws_instance.matrix_server.id
  domain   = "vpc"
}

resource "null_resource" "deploy_matrix" {
  depends_on = [aws_instance.matrix_server]

  provisioner "file" {
    source      = "${path.module}/files/docker-compose.yml"
    destination = "/opt/matrix/docker-compose.yml"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.private_key_path)
      host        = aws_eip.matrix_ip.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd /opt/matrix",
      "sudo docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.private_key_path)
      host        = aws_eip.matrix_ip.public_ip
    }
  }
}

resource "null_resource" "deploy_matrix" {
  depends_on = [aws_instance.matrix_server]

  provisioner "file" {
    source      = "${path.module}/files/docker-compose.yml"
    destination = "/opt/matrix/docker-compose.yml"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.private_key_path)  # Use the private_key_path from the EC2 module
      host        = aws_eip.matrix_ip.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd /opt/matrix",
      "sudo docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.private_key_path)  # Use the private_key_path from the EC2 module
      host        = aws_eip.matrix_ip.public_ip
    }
  }
}