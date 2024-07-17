output "matrix_server_public_ip" {
  description = "The public IP address of the Matrix chat server"
  value       = aws_eip.matrix_ip.public_ip
}

output "matrix_server_instance_id" {
  description = "The instance ID of the Matrix chat server"
  value       = aws_instance.matrix_server.id
}