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

  tags = {
    Name        = "${var.project_name}-${var.environment}-tak-server"
    Environment = var.environment
    Project     = var.project_name
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "S3_BUCKET_NAME=${var.s3_bucket_name}" >> /etc/environment
              
              # Install AWS CLI
              sudo apt-get update
              sudo apt-get install -y awscli unzip
              
              # Create a directory for TAK server files
              sudo mkdir -p /opt/tak
              
              # Download the TAK server ZIP from S3
              aws s3 cp s3://${var.s3_bucket_name}/takserver-docker-5.1-RELEASE-40.zip /opt/tak/
              
              # Unzip the file
              sudo unzip /opt/tak/takserver-docker-5.1-RELEASE-40.zip -d /opt/tak/
              
              # Set appropriate permissions
              sudo chown -R ubuntu:ubuntu /opt/tak
              sudo chmod -R 755 /opt/tak
              
              # Add any additional TAK server setup steps here
              EOF
}

resource "aws_s3_object" "tak_zip" {
  bucket = var.s3_bucket_name
  key    = "takserver-docker-5.1-RELEASE-40.zip"
  source = "${path.module}/files/takserver-docker-5.1-RELEASE-40.zip"
  etag   = filemd5("${path.module}/files/takserver-docker-5.1-RELEASE-40.zip")

  tags = {
    Name        = "TAK Server ZIP"
    Environment = var.environment
    Project     = var.project_name
  }
}