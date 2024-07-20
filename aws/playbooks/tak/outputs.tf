output "public_ip" {
  description = "The public IP address of the TAK server"
  value       = aws_instance.tak_server.public_ip
}

output "instance_id" {
  description = "The instance ID of the TAK server"
  value       = aws_instance.tak_server.id
}