module "tak_iam" {
  source         = "../../modules/iam"
  project_name   = var.project_name
  environment    = var.environment
  service_name   = "tak"
  s3_bucket_name = var.s3_bucket_name
  s3_actions     = ["s3:GetObject", "s3:ListBucket"]
}

resource "aws_instance" "tak_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = module.tak_iam.instance_profile_name
  depends_on = [aws_s3_object.tak_zip]
  tags = {
    Name        = "${var.project_name}-${var.environment}-tak-server"
    Environment = var.environment
    Project     = var.project_name
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "S3_BUCKET_NAME=${var.s3_bucket_name}" >> /etc/environment
              
              # Install AWS CLI
              sudo apt-get update -y
              sudo apt-get install -y awscli unzip git net-tools ca-certificates curl gnupg


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
              
              # Go to home directory where the install files will be housed
              cd /home/
              sudo git clone https://github.com/Cloud-RF/tak-server.git

              # Download the TAK server ZIP from S3
              sudo aws s3 cp s3://${var.s3_bucket_name}/takserver-docker-5.1-RELEASE-40.zip /home/tak-server/

              # using expect to avoid changes to upstream scripts openssl usage
              expect -c "
              spawn ./scripts/setup.sh
              expect {
                  timeout { send \"\r\"; exp_continue }
                  eof
              }
              "
              
              EOF
}

resource "aws_s3_object" "tak_zip" {
  bucket = var.s3_bucket_name
  key    = "takserver-docker-5.1-RELEASE-40.zip"
  source = "${path.module}/files/takserver-docker-5.1-RELEASE-40.zip"
  etag   = filemd5("${path.module}/files/takserver-docker-5.1-RELEASE-40.zip")

  tags = {
    Name        = "${var.project_name}-${var.environment}-tak-server-zip"
    Environment = var.environment
    Project     = var.project_name
  }
}
