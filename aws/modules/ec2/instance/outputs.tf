output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.server.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.server_ip.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.server.private_ip
}