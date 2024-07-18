output "instance_id" {
  description = "ID of the Ubuntu EC2 instance"
  value       = module.ubuntu_server.instance_id
}

output "public_ip" {
  description = "Public IP address of the Ubuntu EC2 instance"
  value       = module.ubuntu_server.public_ip
}