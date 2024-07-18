output "instance_id" {
  description = "ID of the Matrix EC2 instance"
  value       = module.matrix_server.instance_id
}

output "public_ip" {
  description = "Public IP address of the Matrix EC2 instance"
  value       = module.matrix_server.public_ip
}