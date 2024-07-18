output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.instance.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.instance.public_ip
}

output "key_name" {
  description = "Name of the EC2 key pair"
  value       = module.keypair.key_name
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_group.security_group_id
}