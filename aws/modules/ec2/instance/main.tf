resource "aws_instance" "server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.instance_name}"
    Environment = var.environment
    Project     = var.project_name
  }

  user_data = var.user_data

  root_block_device {
    volume_type = "gp2"
    volume_size = var.root_volume_size
  }
}

resource "aws_eip" "server_ip" {
  instance = aws_instance.server.id
  domain   = "vpc"
}